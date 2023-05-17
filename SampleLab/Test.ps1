$templateFile = "./RGDeployment.bicep"
New-AzSubscriptionDeployment `
  -Name LabTest `
  -TemplateFile $templateFile `
  -location eastus `
  -labName "lab-bog-01" `
  -expiryDate "2022-03-20T00:00:00Z"