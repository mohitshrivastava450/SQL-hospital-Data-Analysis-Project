use hospital;

# APPOINTMENTS PER DOCTOR

create view vw_doctor_appointments as 
select doctorid,doctorname,specialization,count(appointmentid) as Total_appointments from doctors
inner join appointment using(doctorid) group by doctorid,doctorname,specialization;

select * from vw_doctor_appointments;

# DOCTOR PERFORMANCE
create view vw_doctor_performance as
select DoctorID,DoctorName,Specialization,count(appointmentid) as Total_appointments,
count(procedureid) as Total_procedures from doctors left join appointment using(doctorid)
left join medical_procedure using(appointmentid) group by doctorid,doctorname,specialization;

select * from vw_doctor_performance;

# REVENUE PER DOCTOR

create view vw_doctor_revenue as
select doctorid,doctorname,sum(amount) as Total_revenue from billing
inner join patients using(patientid) inner join appointment using(patientid)
inner join doctors using(doctorid) group by doctorid,doctorname;

select * from vw_doctor_revenue;

# PATIENT SUMMARY

create view vw_patient_summary as
select patientid,firstname,lastname,count(appointmentid) as Total_appointments,sum(amount) as Total_amount
from patients left join appointment using(patientid) left join billing using(patientid)
group by patientid,firstname,lastname;

select * from vw_patient_summary;

# HOSPITAL DASHBOARD

create view vw_hospital_dashboard as
select (select count(*) from patients) as Total_patients,
(select count(*) from doctors) as Total_doctors,
(select count(*) from appointment) as Total_appointments,
(select sum(amount) from billing) as Total_revenue;

select * from vw_hospital_dashboard;