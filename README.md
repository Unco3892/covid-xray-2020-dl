# Group 5 project: Using Deep Learning to Identify COVID-19 Patients
## Authors: Ilia Azizi & Alexandre Schroeter
## Presented to the [deep learning](https://irudnyts.github.io/deep/) course taught by [Dr.Iegor Rudnytsky](https://irudnyts.github.io)
Welcome on our repo for the project of Deep Learning where we try to apply deep learning techniques on X-rays images to predict if a patient has been infected by COVID-19 or not. 

## Objective
This report has made focused on a binary classification task to identify healthy individuals from those infected by COVID-19, and also a multi-class classification where the task is to identify COVID19+ from healthy individuals or those infected with viral and bacterial pneumonia.

## Structure
### Dataset
All the data used for this project has been placed on this [drive](https://drive.google.com/open?id=128hxYxQ8kVEkSkVGikueiqBxWTmDIW2h). The structure of our datasets are in the following way:

<center>
<table class="tg" width = 80%>
<thead>
  <tr>
    <th class="tg-i7a5"; width = 20%></th>
    <th class="tg-5x9q"; width = 10%>COVID+</th>
    <th class="tg-5x9q"; width = 10%>COVID-</th>
    <th class="tg-5x9q"; width = 10%>Viral Pneumonia</th>
    <th class="tg-5x9q"; width = 10%>Bacterial Pneumonia</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td class="tg-i7a5">Train set</td>
    <td class="tg-3zvv">112</td>
    <td class="tg-3zvv">112</td>
    <td class="tg-3zvv">112</td>
    <td class="tg-3zvv">112</td>
  </tr>
  <tr>
    <td class="tg-i7a5">Small test set</td>
    <td class="tg-3zvv">28</td>
    <td class="tg-3zvv">28</td>
    <td class="tg-3zvv">28</td>
    <td class="tg-3zvv">28</td>
  </tr>
  <tr>
    <td class="tg-i7a5">Large test set</td>
    <td class="tg-3zvv">28</td>
    <td class="tg-3zvv">1583</td>
    <td class="tg-3zvv">1494</td>
    <td class="tg-3zvv">2788</td>
  </tr>
</tbody>
</table>
</center>
&nbsp;
&nbsp;

In the subfolder "data/final_data", you can find the cleaned and pre-processed dataset which has been used for training the models as well as the small test set. Furthermore, the data that was extracted from the sources are found in a folder "data/kermany_OTHERS" which consists of chest-x-ray scans of patients from 2018  who were health (forming our COVID-) or had viral or bacterial types of pneumonia. The source of this dataset can be found on the [dataset's website](https://data.mendeley.com/datasets/rscbjbr9sj/3). </p>
Regarding the pictures that form the COVD+ photos for the training have been retrieved from [chest-x-ray repo](https://github.com/ieee8023/covid-chestxray-dataset) and has been placed in the subfolder "data/chestxray_COVID". Please do not that the latter folder contains not only x-rays but also CT-scans as retrieved in its original form from the repo. </p>
A fourth and a fifth folder have been formed which form a larger test set more to evaluate the model on a realistic scale. Please note that the test set of COVID+ is always 28 photos whether testing on a large or small scale.</p>
Balanced classes of COVID- and both types of pneumonia have been randomly sampled to match the 140 images of COVID+. Furthermore, the script that does this sampling has been placed [here.](https://github.com/deep-class/projg05/blob/master/scripts/import_EDA/photo-organization.R)

### Models and code
Transfer learning with the help of two pre-trained models has been deployed. The first model is VGG16 while the second one is the less parameterized DenseNet201. For both binary and multi-class classification, they have their own [affiliated folders](https://github.com/deep-class/projg05/blob/master/scripts) with the tuning and the final re-training files. The models were tuned on the ai platform of google cloud and can be found in two subfolders and their tuning runs have been placed in the [runs folder.](https://github.com/deep-class/projg05/blob/master/runs)

### Report
The final report can be found in the [report folder](https://github.com/deep-class/projg05/blob/master/report) knitted to Html using the rmarkdown package. Please do note that all the testing runs can be carried out in the same folder.

