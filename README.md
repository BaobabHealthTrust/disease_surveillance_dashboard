Disease surveillance Dashboard

ENVIRONMENT REQUIREMENTS
1. Ruby >= 2.0.0
2. Rails >= 4.0.0

DATABASE
1. Couch DB

BROWSER
1. Firefox >=30

HOW TO SETUP
Make sure you have the source code or you can get it from github

1. git clone git@github.com:BaobabHealthTrust/disease_surveillance_dashboard.git
2. cp config/couchdb.yml.example config/couchdb.yml
Edit couchdb.yml file to match your couch db settings
3. cp config/application.yml.example config/application.yml
Edit the file to point to the address where the OPD application is running
4. rails runner bin/load_diagnosis_type.rb
5. rails runner bin/load_opd_oservations.rb "start_date_here end_date_here"
5. Run the application by typing rails s

