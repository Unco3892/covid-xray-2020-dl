# Group 5 project: Using Deep Learning to predict COVID-19
### Authors: Ilia Azizi & Alexandre Schroeter
Welcome on our repo for the project of Deep Learning where we try to apply deep learning techniques on X-rays images to predict if a patient is COVID+ or not. 

## Dataset
All the data used for this project has been placed on this[drive](https://drive.google.com/open?id=128hxYxQ8kVEkSkVGikueiqBxWTmDIW2h). The structure of our datasets is the following:

<center>
<html>
<body >
<style type="text/css">
.tg  {border-collapse:collapse;border-spacing:0;}
.tg td{border-color:black;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px;
  overflow:hidden;padding:10px 5px;word-break:normal;}
.tg th{border-color:black;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px;
  font-weight:normal;overflow:hidden;padding:10px 5px;word-break:normal;}
.tg .tg-i7a5{font-family:Verdana, Geneva, sans-serif !important;;font-size:14px;text-align:left;vertical-align:top}
.tg .tg-5x9q{font-family:Verdana, Geneva, sans-serif !important;;font-size:14px;font-weight:bold;text-align:left;vertical-align:top}
.tg .tg-3zvv{font-family:Verdana, Geneva, sans-serif !important;;font-size:14px;text-align:center;vertical-align:top}
</style>
<table class="tg" width = 50%>
<thead>
  <tr>
    <th class="tg-i7a5"; width = 20%></th>
    <th class="tg-5x9q"; width = 15%>COVID+</th>
    <th class="tg-5x9q"; width = 15%>COVID-</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td class="tg-i7a5">Train set</td>
    <td class="tg-3zvv">112</td>
    <td class="tg-3zvv">112</td>
  </tr>
  <tr>
    <td class="tg-i7a5">Small test set</td>
    <td class="tg-3zvv">28</td>
    <td class="tg-3zvv">28</td>
  </tr>
  <tr>
    <td class="tg-i7a5">Large test set</td>
    <td class="tg-3zvv">28</td>
    <td class="tg-3zvv">1572</td>
  </tr>
</tbody>
</table>

</body>
</html>
</center>

&nbsp;
&nbsp;
&nbsp;

In the subfolder "data/final_data", you can find the cleaned and processed datasets which has been used for training the models and also contains a test folder for a small test set found in the report. Furthermore talking about the nature of the data itself, 

you would find a folder "data/kermany_OTHERS" which consists of chest-x-ray scans of patients from 2018  who were health (forming our COVID-), or had viral or bacterial pneumonias. The original source of the data can be found on the [dataset's website](https://data.mendeley.com/datasets/rscbjbr9sj/3

The datasets consists of COVD+ samples from the infamous [chest-x-ray repo](https://github.com/ieee8023/covid-chestxray-dataset as well 

## Structure
