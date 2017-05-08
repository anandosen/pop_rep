Disclaimer - No sensitive patient data has been shared in this package. All 'patient' data in this folder is fictitious and were generated for this demonstration only. Once the code is working the data should be replaced with the user's data sets in the format shown in this demonstration.

Notes:

1. This package supports calculating the mGIST and sGISTs for multiple trials. The demonstration covers only one trial but additional trial can be added by simply adding rows to the input files.

2. This package supports 69 study traits. Additional traits can be added  but this will involve minor edits to the one of the functions. More information is provided below.

Input files:

1. dummy_target_pop.txt - the fictitious patient data set
This file is a 250x69 delimited text file containing information for 69 features of 250 patients. Each row corresponds to a patient. The 69 features are in the following order (gender, categorical, laboratory, age):

gender            
alcohol abuse     
anemia            
angina            
arrhythmia        
basal skin cancer        
beta-blocker       
breast feeding            
cancer            
cardiovascular disease        
cerebrovascular disease        
chronic pancreatitis        
cirrhosis         
chronic kidney disease               
coronary artery disease         
cor bypass surgery         
diabetes with ketoacidosis          
dialysis          
drug abuse         
endocrine disease           
gastrointestinal disease         
gastroparesis         
gestational diabetes          
glucagon          
heart failure         
hematological disease          
hepatitis b          
hepatitis c           
HIV               
hypertension          
hypoglyemia           
irritable bowel disease               
kidney disease         
kidney transplant         
liver disease          
major surgery           
metformin         
myocardial infarction        
neuropathy        
panreatitis           
peripheral artery disease         
pre-diabetes           
pregnant          
proliferative retinopathy         
pulmonary disease            
retinopthy        
smoking           
stroke            
substance abuse        
sulfonylurea      
surgery              
thiazolidinediones
thyroid cancer          
transient ischemic attack               
type 1 diabetes          
weight loss surgery       
hba1c             
glucose           
creatanine        
bilirubin         
LDL               
AST              
ALT               
HDL               
hemoglobin        
triglycerides     
total cholesterol       
eGFR              
age  

Note that for each categorical variable (besides gender) the negated binary value is used (0 for presence, 1 for absence). This is because most categorical variables are a part of the exclusion criteria. Additional traits may be included by inserting extra columns. However, the overall order of gender, categorical, laboratory, age must be maintained.

2. trial_lab_elig.txt
This file determines which of the above laboratory traits are eligibility traits. Each row corresponds to a trial. The first column contains the trial identifier while the next 12 contain the eligibility status for each of the laboratory traits. Additional traits may be included by inserting extra columns.

3. cat_trials_data.txt
This file determines which of the above categorical traits are eligibility traits. Each row corresponds to a trial. The first column contains the trial identifier while the next 55 contain the eligibility status for each of the categorical traits. Additional traits may be included by inserting extra columns.

4. trials_by_gender.txt
This file contains the gender restrictions for each trial. Each row corresponds to a trial. The only column determines the gender status - 0 for both genders eligible, 1 for females eligible only and 2 for males eligible only.

5. trials_by_feat.txt and lab_fil_list.txt
These files contain the source filenames (source files not a part of this package) for the categorical and lab features respectively. They are used to create a list of traits.

6. tr_elig_age.txt
This file contains the eligibility criteria for age for each trial. Each row corresponds to a trial. The three columns consist of the trial identifier, lower limit and upper limit. Default limits are set to 18 and 90.

7. tr_{labfeat}.txt - e.g. tr_hba1c.txt, tr_gluc.txt, etc. (total 12 files)
These files contain the eligibility criteria for each lab trait. Each row corresponds to a trial. The 4 columns correspond to trial identifier, lower limit, upper limit and eligibility status (whether an eligibility criterion or not). Default limits are set to arbitrarily small and large values - 0 and 2000. For each additional trait added by the user, a similar file (in the same format) must be generated.

Matlab Scripts (tested on Matlab 2015b):

1. mgist_main.m 
This is the main program for computing the mGIST and sGIST scores. It is ready to run as long as all input files are in order. All other matlab scripts are functions that are called from this script. The output is written into two ouput files described below.

2. strin_weights.m
This function computes the weights of every study trait based on the stringency of its eligibility criterion.

3. get_critera.m
This function reads the upper and lower limits of all the laboratory eligibility criteria and age from the input files described in 6 and 7. If additional traits are added for the user's experiments, the name of the corresponding tr_{labfeat}.txt files must be added to the cell variable 'lab_elig_list' in the correct position.

4. gmult_cat.m
This function applies the eligibility criteria to determine the traitwise an overall eligibility of a patient for all traits. 

Output files:
1. result_table.txt and result_table.csv
The output files are provided in two formats - ASCII delimited and CSV. Each row corresponds to a trial. There are 71 columns. Trial identifier, the sGIST scores for the 69 traits in the same order as above and the mGIST score. If a trait is not an eligibility trait, its sGIST entry is marked as 100.

Inquiries and Suggestions:
Dr. Anando Sen
anandosen@gmail.com  


