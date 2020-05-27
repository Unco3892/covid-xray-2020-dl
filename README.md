# Group 5 project: Using Deep Learning to predict COVID-19
### Authors: Ilia Azizi & Alexandre Schroeter
Welcome on our repo for the project of Deep Learning where we try to apply deep learning techniques on X-rays images to predict if a patient is COVID+ or not. 

## Dataset
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

In the subfolder "data/final_data", you can find the cleaned and pre-processed dataset which has been used for training the models as well as the small test set. Furthermore, the data that was extracted from the sources are found in a folder "data/kermany_OTHERS" which consists of chest-x-ray scans of patients from 2018  who were health (forming our COVID-), or had viral or bacterial pneumonias. The original source of the data can be found on the [dataset's website](https://data.mendeley.com/datasets/rscbjbr9sj/3). The dataset that form the COVD+ photos for the training has been retrieved from the [chest-x-ray repo](https://github.com/ieee8023/covid-chestxray-dataset).

## Structure

