# CREATING DATABASE

create database hospital;
use hospital;

------------------------------------------------------------------------------------------------

# CREATING TABLES

create table Patients(PatientID int primary key,Firstname varchar(50),Lastname varchar(50),Email varchar(50));

create table doctors(DoctorID int primary key,DoctorName varchar(50),Specialization varchar(50),DoctorContact varchar(50));

create table appointment(AppointmentID int primary key,AppointmentDate varchar(50),PatientID int,DoctorID int,
foreign key  (PatientID) references Patients(PatientID),foreign key  (DoctorID) references doctors(DoctorID));

create table Medical_Procedure(ProcedureID int primary key,ProcedureName varchar(50),AppointmentID int,
foreign key  (AppointmentID) references appointment(AppointmentID));

create table billing(InvoiceID varchar(50) primary key,PatientID int,Items varchar(50),Amount int,
foreign key  (PatientID) references Patients(PatientID));

------------------------------------------------------------------------------------------------

# LOADING DATA IN THE TABLES

show variables like 'secure%';

LOAD DATA  INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Patient.csv'
INTO TABLE Patients
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA  INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Doctor.csv'
INTO TABLE doctors
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA  INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Appointment.csv'
INTO TABLE appointment
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA  INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Medical Procedure.csv'
INTO TABLE Medical_Procedure
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


LOAD DATA  INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Billing.csv'
INTO TABLE billing
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

------------------------------------------------------------------------------------------------

# DATA CLEANING

select * from billing order by items asc;
set sql_safe_updates=0;
delete from billing where items='';

------------------------------------------------------------------------------------------------

# CHANGING DATA TYPE 

alter table appointment add column Appointment_date date;
update appointment set appointment_date=str_to_date(AppointmentDate,"%d-%m-%Y");
desc appointment;
select * from appointment;
alter table appointment drop column AppointmentDate;

------------------------------------------------------------------------------------------------

# DATA ANALYSIS QUESTIONS

# 1. PATIENT ANALYSIS

# 1.How many total patients are registered?
# 2.How many patients have at least one appointment?
# 3.Which patients visited the hospital most frequently?
# 4.Which patient generated the highest total billing amount?
# 5.Top 10 patients by total spending.

# 1.How many total patients are registered?
select count(*) as total_patients_registered from patients;
 
# 2.How many patients have at least one appointment?
select count(distinct PatientID) as total_patients_appointment from appointment;

# 3.Which patients visited the hospital most frequently?
select p.PatientID,concat(p.firstname," ",p.lastname) as Patient_Name,count(a.AppointmentID) as Total_Appointments
from appointment a inner join patients p on a.PatientID=p.PatientID group by p.PatientID,Patient_Name 
order by Total_Appointments desc limit 10;

# 4.Which patient generated the highest total billing amount?
select p.PatientID,concat(p.firstname," ",p.lastname) as Patient_Name,sum(b.Amount) as Total_Billing_Amount
from patients p inner join Billing b on p.PatientID=b.PatientID group by p.PatientID,Patient_Name 
order by Total_Billing_Amount desc limit 1;

# 5.Top 10 patients by total spending.
select p.PatientID,concat(p.firstname," ",p.lastname) as Patient_Name,sum(b.Amount) as Total_Billing_Amount
from patients p inner join Billing b on p.PatientID=b.PatientID group by p.PatientID,Patient_Name 
order by Total_Billing_Amount desc limit 10;



# 2. DOCTOR AND SPECIALIZATION ANALYSIS

# 1.How many doctors are there?
# 2.How many doctors per specialization?
# 3.Which specialization has the most doctors?
# 4.Which doctor handled the most appointments?
# 5.Which specialization receives the highest number of appointments?

# 1.How many doctors are there?
select count(*) as Total_Doctors from doctors;

# 2.How many doctors per specialization?
select Specialization,count(*) as Number_of_doctors from doctors group by Specialization;

# 3.Which specialization has the most doctors?
select Specialization,count(*) as Number_of_doctors from doctors group by Specialization 
order by Number_of_doctors desc limit 10;

# 4.Which doctor handled the most appointments?
select d.Doctorid,d.Doctorname,count(AppointmentID) as Total_Appointments from doctors d inner join appointment a
on d.doctorid=a.doctorid group by d.doctorid,d.DoctorName order by Total_Appointments desc limit 10;
 
# 5.Which specialization receives the highest number of appointments?
select d.specialization,count(a.appointmentid) Number_of_appointments from doctors d inner join appointment a
on d.DoctorID=a.DoctorID group by d.Specialization order by Number_of_appointments desc limit 10;



# 3. APPOINTMENT ANALYSIS

# 1.Find total number of appointments.
# 2.Find appointments per doctor.
# 3.Find appointments per date.
# 4.Which date had the highest number of appointments?
# 5.Which patient-doctor pair has the most appointments?

# 1.Find total number of appointments.
select count(*) as Total_appointments from appointment;

# 2.Find appointments per doctor.
select d.doctorid,d.doctorname,count(a.appointmentid) as Number_of_appointments from appointment a inner join doctors d
on a.DoctorID=d.DoctorID group by d.DoctorID,d.DoctorName;

# 3.Find appointments per date.
select appointment_date,count(appointmentid) as number_of_appointments from appointment
group by appointment_date;

# 4.Which date had the highest number of appointments?
select appointment_date,count(appointmentid) as number_of_appointments from appointment
group by appointment_date order by number_of_appointments desc limit 10;
 
# 5.Which patient-doctor pair has the most appointments?
select p.patientid,concat(p.firstname," ",p.lastname) as Patient_Name,d.doctorid,d.doctorname,count(a.appointmentid)
as number_of_appointments from appointment a inner join doctors d on a.DoctorID=d.DoctorID
inner join patients p on a.PatientID=p.PatientID group by p.patientid,Patient_Name,d.doctorid,d.doctorname 
order by number_of_appointments desc limit 10;



# 4. MEDICAL PROCEDURE ANALYSIS

# 1.Find total number of procedures performed.
# 2.Find most frequently performed procedure.
# 3.Find procedures per doctor.
# 4.Which procedure generates the most billing amount?
# 5.Which doctor performs the most procedures?

# 1.Find total number of procedures performed.
select count(*) as Total_procedures from medical_procedure;

# 2.Find most frequently performed procedure.
select Procedurename,count(*) as number_of_procedures from medical_procedure 
group by ProcedureName order by number_of_procedures desc limit 10;

# 3.Find procedures per doctor.
select DoctorID,Doctorname,count(ProcedureID) as number_of_procedures from medical_procedure
inner join appointment using(AppointmentID) inner join doctors using(DoctorID)
group by DoctorID,DoctorName;

# 4.Which procedure generates the most billing amount?
select ProcedureName,sum(amount) as Total_amount from medical_procedure inner join billing on ProcedureName=Items 
group by ProcedureName order by Total_amount desc limit 10;

# 5.Which doctor performs the most procedures?
select DoctorID,Doctorname,count(ProcedureID) as number_of_procedures from medical_procedure
inner join appointment using(AppointmentID) inner join doctors using(DoctorID)
group by DoctorID,DoctorName order by number_of_procedures desc limit 10;



# 5.BILLING & REVENUE ANALYSIS

# 1.Total revenue generated.
# 2.Find average bill amount.
# 3.Find highest single invoice.
# 4.Find revenue by patient.
# 5.Find revenue by procedure.
# 6.Find revenue by doctor.
# 7.Find patients with appointments but no billing.

# 1.Total revenue generated.
select sum(amount) as Total_revenue from billing;

# 2.Find average bill amount.
select avg(amount) as average_bill_amount from billing;

# 3.Find highest single invoice.
select * from billing order by amount desc limit 1;

# 4.Find revenue by patient.
select Patientid,firstname,lastname,sum(amount) from billing 
inner join patients using(patientid) group by Patientid,firstname,lastname;
 
# 5.Find revenue by procedure.
select procedurename,sum(amount) as Total_revenue from billing inner join medical_procedure
on items=ProcedureName group by ProcedureName;
 
# 6.Find revenue by doctor.
select doctorid,doctorname,sum(amount) as Total_revenue from billing
inner join patients using(patientid) inner join appointment using(patientid)
inner join doctors using(doctorid) group by doctorid,doctorname;

# 7.Find patients with appointments but no billing.
select distinct p.patientid,p.firstname,p.lastname from patients p
inner join appointment a on p.PatientID=a.PatientID left join billing b on p.PatientID=b.PatientID
where b.PatientID is null;

------------------------------------------------------------------------------------------------