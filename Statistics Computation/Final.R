library(shiny)
library(plotly)
library(shinythemes)
library(DMwR2)
library(missMDA)
library(CDLasso)
library(png)

#Q:Hwo to put the columns name into UI interface.

data = read.csv('C:/Users/jiao/Desktop/M_D/2022-2023/Subject/Statistic_Conputation/HW/Final/final_train.csv', fileEncoding = "UTF-8-BOM")
#data = read.csv('C:/Users/jiao/Desktop/M_D/2022-2023/Subject/Statistic_Conputation/HW/Final/WA_Fn-UseC_-HR-Employee-Attrition_train.csv', fileEncoding = "UTF-8-BOM")


imputation_name = c('Delete','By mean','KNN','PCA')
model_name = c('Lasso','Ridge')
rescale_name = c('Orig','[0,1]','[-1,1]','standard')
metrics_name = c('MSE','RMSE','MAE')



to.0.1 = function(x){
  (x-min(x))/(max(x)-min(x))
}

to.1.1 = function(x){
  2*(x-min(x))/(max(x)-min(x))-1
}

to.z.score = function(x){
  (x-mean(x))/sd(x)
}


MSE = function(x1,x2){
  mean((x1-x2)^2)
}
RMSE = function(x1,x2){
  sqrt(mean((x1-x2)^2))
}
MAE = function(x1,x2){
  mean(abs(x1-x2))
}


ui <- navbarPage("L1 nad L2 Regression Model",
                 tabPanel("Simple EDA",
                          fluidPage(theme = shinytheme("flatly")),
                          pageWithSidebar(
                            headerPanel('Import data'),
                            sidebarPanel(
                              fileInput("file1", "Choose CSV File"),
                              sliderInput("Pro", "Proportion of train data:", min = 10, max = 100, value = 80, step = 10),
                              selectInput("Imp", "method of Imputation", imputation_name, selected = imputation_name[1]),
                              selectInput("Res", "method of Rescale", rescale_name, selected = rescale_name[1]),
                              selectInput("Fea", "Features", colnames(data), selected = colnames(data)[1],multiple = TRUE),
                              selectInput("Lab", "Labels", colnames(data), selected = colnames(data)[1]),
                              textOutput("Whemis",inline=T),
                              tags$head(tags$style("#Whemis{color: red;
                                 font-size: 16px;
                                 font-style: italic;
                                 }")),
                              p('NOTE : We will cancel those columns that all consist of the same elements.'),
                              hr(),
                              actionButton("Sub1", "Submit")),
                            mainPanel(fluidPage(fluidRow(
                              downloadButton('download1',"Download the training data"),
                              dataTableOutput('EDAdata1'),
                              downloadButton('download2',"Download the testing data"),
                              dataTableOutput('EDAdata2'))))
                          )),
                 tabPanel("Fit Model",
                          fluidPage(withMathJax(),
                                    theme = shinytheme("flatly")),
                          tags$head(
                            tags$style(HTML(".shiny-output-error-validation{color: red;}"))),
                          pageWithSidebar(
                            headerPanel('Choose model'),
                            sidebarPanel(
                              selectInput("ModT", "Model you want to use", model_name, selected = model_name[1])
                              ,textInput("ld","Choose lambda")
                              ,selectInput("Met", "Metrics you want to use", metrics_name, selected = model_name[1])
                              ,actionButton("Sub2", "Fit")),
                            mainPanel(
                              textOutput("Modelname",inline=T)
                              ,tags$head(tags$style("#Modelname{color: black;
                              font-size: 18px;
                              font-style: italic;
                              }"))
                              ,uiOutput("ex1")
                              ,uiOutput("ex2")
                              ,textOutput("Metr",inline=T))
                            )),
                 tabPanel("Predict real data by pre-fitted model",
                          fluidPage(theme = shinytheme("flatly")),
                          fileInput("file2", "Choose train_data.csv"),
                          tags$small('Note:the shape of data must be [NA,nrow(training_data)]'),
                          pageWithSidebar(
                            headerPanel('Prediction'),
                            sidebarPanel(actionButton("Sub3", "Predict")),
                          mainPanel(
                            textOutput("Modelname2",inline=T)
                            ,tags$head(tags$style("#Modelname{color: black;
                              font-size: 18px;
                              font-style: italic;
                              }"))
                            ,downloadButton('download3',"Download prediction result")
                            ,dataTableOutput('res'))
                        )),
                 tabPanel("Introduction and Reference",
                          fluidPage(
                            column(10,
                                   titlePanel("Introduction"),
                                   textOutput('Int1'),
                                   tags$head(tags$style("#Int1{color: black; font-size: 20px; font-style: italic;}"))
                                   ),
                            column(10
                                 ,titlePanel("Reference")
                                 ,p(a("Imputation by PCA", href="https://www.rdocumentation.org/packages/missMDA/versions/1.18/topics/imputePCA", target="_blank"), style = "font-size:18px")
                                 ,p(a("Imputation by KNN", href="https://www.rdocumentation.org/packages/DMwR/versions/0.4.1/topics/knnImputation", target="_blank"), style = "font-size:18px")
                                 ,p(a("Lasso document", href="https://www.rdocumentation.org/packages/CDLasso/versions/1.1/topics/l1.reg", target="_blank"), style = "font-size:18px")
                                 ,p(a("Ridge document", href="https://www.rdocumentation.org/packages/CDLasso/versions/1.1/topics/l2.reg", target="_blank"), style = "font-size:18px")
                                  ),
                            column(12,align='center'
                                   ,p(a("e-mail : yhocotw31016@gmail.com", href="https://www.google.com/intl/zh-TW_tw/gmail/about/", target="_blank"), style = "font-size:18px")),
                                  )
                          )
)

# Define server
server = function(input, output) {
  
  # Page 4
  output$Int1 = renderText({'This app will help you primally do EDA (Exploratory Data Analysis) for training data, it\'s convenient to split your training and testing set and choose the features and label if you don\'t want to choose all features to fit/train the model. And if Lasso/Ridge regression is your \'fantasy\' model, that\'s great! you can easily fit the data which comes from previous page after choosing the regression model and the value lambda. Finally, you can predict the data whose dimension of features need to same to the dimension of previous training data whose dimension of features need to same to the dimension of previous training set, because the parameter of model is fitted by previous traning set.'})
  
  # Page1
  whether.imp = reactive({
    
    dat = input$file1
    if(is.null(dat))
      return(NULL)
    dat = read.csv(dat$datapath, fileEncoding = "UTF-8-BOM")
    
    if (sum(is.na(dat))>0){
      return('There are missing value.')
    } else {
      return('!There is no missing value!')}
  })
  
  output$Whemis = renderText({ 
    whether.imp()
  })
  
  EDA.dat = eventReactive(input$Sub1 ,{
    
    dat = input$file1
    if(is.null(dat))
      return(NULL)
    dat = read.csv(dat$datapath, fileEncoding = "UTF-8-BOM")
    
    # Categorical to numerical and delete the column consisting of all same element
    for (i in 1:ncol(dat)){
      s=0
      tryCatch({
        dat[,i]/10
        s=1
      }, warning = function(war) {
      }, error = function(err) {
      }, finally = {
        if (s==0){
          dat[,i] = unclass(as.factor(dat[,i]))
        }
      })
    }
    
    dcol=c()
    for (i in 1:ncol(dat)){
      ini = dat[1,i]
      num = 2
      while (TRUE){
        if(is.na(ini)){
          ini = dat[num,i]
          num=num+1
        } else{
          if (is.na(dat[num,i])){
            num=num+1
          } else{
            if (ini!=dat[num,i]){
              break
            }else if (num==nrow(dat)) { 
              dcol = cbind(dcol,i)
              break
            } else {
              num = num+1
            }
          }
        }
      }
    }
    
    if (length(dcol)!=0){dat = dat[,-dcol]}
    
    # to numeric
    for (i in 1:ncol(dat)){
      dat[,i]=as.numeric(dat[,i])
    }
    
    # imputation
    if (input$Imp==imputation_name[1]){
      im.dat = dat[complete.cases(dat),]
    } else if (input$Imp==imputation_name[2]){
      for(i in 1:ncol(dat)){
        m = mean(dat[, i], na.rm = T)
        na.rows = is.na(dat[, i])
        dat[na.rows, i] = m
      }
      im.dat = dat
    } else if (input$Imp==imputation_name[3]){
      im.dat = knnImputation(dat)
    } else{
      im.dat = imputePCA(dat)}
    
    # rescale
    if (input$Res==rescale_name[1]){
      re.dat = im.dat
    } else if (input$Res==rescale_name[2]){
      for (i in 1:ncol(im.dat)) {
        im.dat[,i] = to.0.1(im.dat[,i])
      }
      re.dat=im.dat
    } else if (input$Res==rescale_name[3]){
      for (i in 1:ncol(im.dat)) {
        im.dat[,i] = to.1.1(im.dat[,i])
      }
      re.dat=im.dat
    } else{
      for (i in 1:ncol(im.dat)) {
        im.dat[,i] = to.z.score(im.dat[,i])
      }
      re.dat = im.dat
    }
    
    Fea = input$Fea
    Lab = input$Lab
    
    # random split
    sample.size = ceiling(input$Pro/100*nrow(re.dat))
    idx = sample(seq_len(nrow(re.dat)),size = sample.size)
    train.data = re.dat[idx,]
    test.data = re.dat[-idx,]
    x_train = train.data[,Fea]
    y_train = matrix(train.data[,Lab],nrow(train.data),1)
    x_test = test.data[,Fea]
    y_test = matrix(test.data[,Lab],nrow(test.data),1)
    
    dis.train = data.frame(x_train,y_train)
    dis.test = data.frame(x_test,y_test)
    
    #list(train=dis.train, test=dis.test)
    list(x_train=x_train,y_train=y_train,
         x_test=x_test,y_test=y_test,
         train=dis.train, test=dis.test)
  })
  
  
  output$download1 = downloadHandler(
    filename = function(){"train.csv"}, 
    content = function(fname){
      write.csv(EDA.dat()$train, fname)
    }
  )
  output$download2 = downloadHandler(
    filename = function(){"test.csv"}, 
    content = function(fname){
      write.csv(EDA.dat()$test, fname)
    }
  )
  
  output$EDAdata1 = renderDataTable(EDA.dat()$train,
                                    options = list(
                                      pageLength = 7))
  
  output$EDAdata2 = renderDataTable(EDA.dat()$test,
                                    options = list(
                                      pageLength = 7))
  
  
  # Page2
  Predict.model = eventReactive(input$Sub2 ,{
    
    x_train = EDA.dat()$x_train
    y_train = EDA.dat()$y_train
    x_test = EDA.dat()$x_test
    y_test = EDA.dat()$y_test
    
    if (input$ModT==model_name[1]) {
      fit.L1 = l1.reg(t(x_train), y_train, lambda = input$ld)
      y.pre = data.matrix(x_test)%*%fit.L1$estimate
      met = input$Met
      if (met=='MSE') {
        err = MSE(y.pre,y_test)
        metr = '$$\\frac{1}{n}||Y-\\hat Y||^2$$'
      } else if (met=='RMSE') {
        err = RMSE(y.pre,y_test)
        metr = '$$\\sqrt{\\frac{1}{n}||Y-\\hat Y||^2}$$'
      } else if (met=='MAE') {
        err = MAE(y.pre,y_test)
        metr = '$$\\frac{1}{n}||Y-\\hat Y||$$'
      } else {}
      Model = fit.L1
      formula = '$$argmin_\\beta f(X,Y)=argmin_\\beta(||Y-\\beta X||^2+\\lambda |\\beta|)$$'
    } else {
      fit.L2 = l2.reg(t(x_train), y_train, lambda = input$ld)
      y.pre = data.matrix(x_test)%*%fit.L2$estimate
      met = input$Met
      if (met=='MSE') {
        err = MSE(y.pre,y_test)
        metr = '$$\\frac{1}{n}||Y-\\hat Y||^2$$'
      } else if (met=='RMSE') {
        err = RMSE(y.pre,y_test)
        metr = '$$\\sqrt{\\frac{1}{n}||Y-\\hat Y||^2}$$'
      } else if (met=='MAE') {
        err = MAE(y.pre,y_test)
        metr = '$$\\frac{1}{n}||Y-\\hat Y||$$'
      } else {}
      Model = fit.L2
      formula = '$$argmin_\\beta f(X,Y)=argmin_\\beta(||Y-\\beta X||^2+\\lambda ||\\beta||^2)$$'
    } 
    
    return(list(Model=Model, something = paste('We have chosen the model','\'',input$ModT,'\''),
                formula = formula,metr = metr,err=err))
  })
  
  output$Modelname = renderText({ 
    paste(Predict.model()$something,'with lambda =',input$ld,'to fit the data getting from previous page.')
  })
  
  output$ex1 = renderUI({
    withMathJax(helpText('Goal :', Predict.model()$formula,'\nmetric is',input$Met,':',Predict.model()$metr))
  })
  
  output$Metr = renderText({ 
    paste('error :',Predict.model()$err)
  })
 
  
  # Page3
  Prediction = eventReactive(input$Sub3 ,{
    
    dat = input$file2
    if(is.null(dat))
      return(NULL)
    dat = read.csv(dat$datapath, fileEncoding = "UTF-8-BOM")
    
    # Categorical to numerical and delete the column consisting of all same element
    for (i in 1:ncol(dat)){
      s=0
      tryCatch({
        dat[,i]/10
        s=1
      }, warning = function(war) {
      }, error = function(err) {
      }, finally = {
        if (s==0){
          dat[,i] = unclass(as.factor(dat[,i]))
        }
      })
    }
    
    dcol=c()
    for (i in 1:ncol(dat)){
      ini = dat[1,i]
      num = 2
      while (TRUE){
        if(is.na(ini)){
          ini = dat[num,i]
          num=num+1
        } else{
          if (is.na(dat[num,i])){
            num=num+1
          } else{
            if (ini!=dat[num,i]){
              break
            }else if (num==nrow(dat)) { 
              dcol = cbind(dcol,i)
              break
            } else {
              num = num+1
            }
          }
        }
      }
    }
    
    if (length(dcol)!=0){dat = dat[,-dcol]}
    
    # to numeric
    for (i in 1:ncol(dat)){
      dat[,i]=as.numeric(dat[,i])
    }
    
    # imputation
    if (input$Imp==imputation_name[1]){
      im.dat = dat[complete.cases(dat),]
    } else if (input$Imp==imputation_name[2]){
      for(i in 1:ncol(dat)){
        m = mean(dat[, i], na.rm = T)
        na.rows = is.na(dat[, i])
        dat[na.rows, i] = m
      }
      im.dat = dat
    } else if (input$Imp==imputation_name[3]){
      im.dat = knnImputation(dat,k=2)
    } else {
      im.dat = imputePCA(dat,ncp=3)$completeObs}
    
    # rescale
    if (input$Res==rescale_name[1]){
      re.dat = im.dat
    } else if (input$Res==rescale_name[2]){
      for (i in 1:ncol(im.dat)) {
        im.dat[,i] = to.0.1(im.dat[,i])
      }
      re.dat=im.dat
    } else if (input$Res==rescale_name[3]){
      for (i in 1:ncol(im.dat)) {
        im.dat[,i] = to.1.1(im.dat[,i])
      }
      re.dat=im.dat
    } else{
      for (i in 1:ncol(im.dat)) {
        im.dat[,i] = to.z.score(im.dat[,i])
      }
      re.dat = im.dat
    }    

    y = data.matrix(re.dat)%*%Predict.model()$Model$estimate
    
    return(data.frame(dat,y))
  })
  
  
  output$download3 = downloadHandler(
    filename = function(){"result.csv"}, 
    content = function(fname){
      write.csv(Prediction(), fname)
    }
  )
  
  output$res = renderDataTable(Prediction(),
                                    options = list(
                                      pageLength = 7))
  output$Modelname2 = renderText({ 
    paste(Predict.model()$something,'with lambda =',input$ld,'to fit the data getting from previous page.')
  })
  
}

shinyApp(ui = ui, server = server)