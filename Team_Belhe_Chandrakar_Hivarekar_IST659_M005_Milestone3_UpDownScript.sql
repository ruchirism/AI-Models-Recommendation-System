/* This sql file contains the loaded data script with views and procedures for our project 
which is called AI Models Recommendation System that is made by Arsh Chandrakar, 
Ruchir Hivarekar, and Arya Belhe for Project Milestone 3*/

if not exists(select * from sys.databases where name='AIModels')
    create database AIModels
go

use AIModels
go

-- DOWN
-- Dropping all the existing tables in the database.
drop table if exists model_eval_achievement;
drop table if exists model_user;
drop table if exists evaluations;
drop table if exists models;
drop table if exists organizations;
drop table if exists pricings;
drop table if exists categories;
drop table if exists users;

go

-- UP Metadata
-- Creating a table to hold the information and other constraints of users
create table users (
    user_id int identity not null,
    user_firstname varchar(50) not null,
    user_lastname varchar(50) not null,
    user_email varchar(255) not null,
    user_contact varchar(50) not null,
    user_city varchar(50) not null,
    user_region varchar(50) null,
    user_country varchar(50) not null,
    user_zipcode varchar(50) not null,
    constraint pk_users_user_id primary key (user_id),
    constraint u_users_user_email unique (user_email),
    constraint ck_users_user_contact check (len(user_contact) = 10)
);

-- Creating a table that hold the information about categories of the AI models
create table categories (
    category_id int identity(1,1) not null,
    category_name varchar(255) not null,
    category_description varchar(255) null,
    category_tag varchar(255) null,
    constraint pk_categories_category_id primary key (category_id),
    constraint u_categories_category_name unique (category_name)
);

-- Creating a table that holds the information about pricing of the AI models
create table pricings (
    pricing_id int identity not null,
    pricing_plans varchar(255) null,
    pricing_charges varchar(50) null,
    pricing_benefit varchar(255) null,
    constraint pk_pricings_pricing_id primary key (pricing_id)
);

-- Creating a table that contains the details of the organizations and its constraints
create table organizations (
    organization_id int identity not null,
    organization_name varchar(255) not null,
    organization_email varchar(50) not null,
    organization_contact varchar(50) not null,
    organization_city varchar(50) not null,
    organization_region varchar(50) null,
    organization_country varchar(50) not null,
    organization_zipcode varchar(50) not null,
    constraint pk_organizations_organization_id primary key (organization_id),
    constraint u_organizations_organization_email unique (organization_email),
    constraint ck_organization_organization_name check (len(organization_name) != 0)
);

-- Creating a table to hold all information about models and its constraints
create table models (
    model_id int identity not null,
    model_name varchar(50) not null,
    model_usage varchar(255) not null,
    model_feature varchar(255) not null,
    model_dependancy varchar(255) null,
    model_pricing_id int not null,
    model_category_id int not null,
    model_organization_id int not null,
    model_user_id int not null,
    constraint pk_models_model_id primary key (model_id),
    constraint u_models_model_name unique (model_name),
    constraint ck_models_model_name check (len(model_name) != 0)
);

-- Creating a table hold information about evaluation parameters for the AI models
create table evaluations (
    eval_id int identity not null,
    eval_threshold varchar(255) not null,
    eval_goal varchar(255) null,
    constraint pk_evaluations_eval_id primary key (eval_id),
    constraint ck_evaluations_eval_threshold check (len(eval_threshold) != 0)
);

-- Creating a bridge table for models and users as they both can have multiple
-- values of each other
create table model_user (
    rating_user_id int not null,
    rating_model_id int not null,
    rating_value int null,
    rating_comment varchar(255) null,
    rating_source varchar(255) null,
    constraint pk_rating_model_user_id primary key (rating_user_id, rating_model_id)
);

-- Creating a bridge table for models and evaluations as they both can have multiple
-- values of each other
create table model_eval_achievement (
    eval_id int not null,
    model_id int not null,
    metric varchar(255) not null,
    constraint pk_model_eval_ids primary key (model_id, eval_id)
);

alter table models
    add constraint fk_model_pricing_id foreign key (model_pricing_id)
        references pricings(pricing_id);
alter table models
    add constraint fk_model_category_id foreign key (model_category_id)
        references categories(category_id);
alter table models
    add constraint fk_model_organization_id foreign key (model_organization_id)
        references organizations(organization_id);
alter table model_user
    add constraint fk_rating_user_id foreign key (rating_user_id)
        references users(user_id);
alter table model_user
    add constraint fk_rating_model_id foreign key (rating_model_id)
        references models(model_id);
/*alter table models
    add constraint fk_model_user_id foreign key (user_id)
        references users(user_id); */
alter table model_eval_achievement
    add constraint fk_model_eval_model_id foreign key (model_id)
        references models(model_id);
alter table model_eval_achievement
    add constraint fk_model_eval_eval_id foreign key (eval_id)
        references evaluations(eval_id);

go

-- UP Data
-- insert 10 records into users table
set IDENTITY_insert users on
insert into users (user_id,user_firstname,user_lastname,user_email,user_contact,user_city,user_region,user_country,user_zipcode)
    values
        (1,'Arsh', 'Chandrakar', 'arsh@gmail.com', '1234567890', 'New York', 'NY', 'USA', '10001'),
        (2,'Arya', 'Belhe', 'arya@gmail.com', '0987654321', 'Los Angeles', 'CA', 'USA', '90001'),
        (3,'Ruchir', 'Hivarekar', 'ruchir@gmail.com', '9876543210', 'Chicago', 'IL', 'USA', '60601'),
        (4,'Sanket', 'Mane', 'sanket@gmail.com', '4567890123', 'Houston', 'TX', 'USA', '77001'),
        (5,'Rakesh', 'Bhat', 'rbhat@gmail.com', '2345678901', 'Phoenix', 'AZ', 'USA', '85001'),
        (6,'Narendra', 'Modi', 'nmodi@gmail.com', '8765432109', 'Philadelphia', 'PA', 'USA', '19101'),
        (7,'Kajal', 'Kale', 'kajal@gmail.com', '6543210987', 'San Antonio', 'TX', 'USA', '78201'),
        (8,'Rutuja', 'Kajale', 'rutuja@gmail.com', '3456789012', 'San Diego', 'CA', 'USA', '92101'),
        (9,'Sophia', 'Anderson', 'sophia.anderson@example.com', '7890123456', 'Dallas', 'TX', 'USA', '75201'),
        (10,'William', 'Taylor', 'william.taylor@example.com', '2109876543', 'San Jose', 'CA', 'USA', '95101');

set IDENTITY_insert users off

-- insert 10 records into categories table
insert into categories (category_name, category_description, category_tag)
values
    ('Machine Learning', 'Models and algorithms for ML', 'ml'),
    ('Deep Learning', 'Neural networks and deep learning models', 'dl'),
    ('Natural Language Processing', 'Text and speech processing models', 'nlp'),
    ('Computer Vision', 'Image and video processing models', 'cv'),
    ('Reinforcement Learning', 'Models for decision-making and control', 'rl'),
    ('Generative Models', 'Models for generating data like images, text, etc.', 'generative'),
    ('Optimization', 'Models and algorithms for optimization problems', 'optimization'),
    ('Recommender Systems', 'Models for recommendation and personalization', 'recommender'),
    ('Time Series Forecasting', 'Models for forecasting time series data', 'timeseries'),
    ('Anomaly Detection', 'Models for detecting anomalies in data', 'anomaly');

-- insert 10 records into pricings table
insert into pricings (pricing_plans, pricing_charges, pricing_benefit)
values
    ('Free', 'Free', 'Basic features and limited usage'),
    ('Basic', '$9.99/month', 'Standard features and moderate usage'),
    ('Pro', '$29.99/month', 'Advanced features and high usage'),
    ('Enterprise', 'Custom pricing', 'Customized features and unlimited usage'),
    ('Startup', '$14.99/month', 'Discounted pricing for startups'),
    ('Academic', '$4.99/month', 'Discounted pricing for academic institutions'),
    ('Team', '$99.99/month', 'Collaborative features for teams'),
    ('Individual', '$19.99/month', 'Personalized features for individuals'),
    ('Pay-as-you-go', 'Usage-based pricing', 'Pay only for what you use'),
    ('Annual subscription', 'Discounted annual pricing', 'Save with an annual subscription');


-- insert 10 records into organizations table
insert into organizations (organization_name, organization_email, organization_contact, organization_city, organization_region, organization_country, organization_zipcode)
values
    ('Acme Inc.', 'contact@acme.com', '315-555-1234', 'New York', 'New York', 'USA', '10001'),
    ('Globex Corp.', 'info@globex.com', '987-555-5678', 'San Francisco', 'California', 'USA', '94101'),
    ('Stark Industries', 'info@stark.com', '867-555-9012', 'Los Angeles', 'California', 'USA', '90001'),
    ('Umbrella Corp.', 'contact@umbrella.com', '987-555-3456', 'Chicago', 'Illinois', 'USA', '60601'),
    ('Cyberdyne Systems', 'info@cyberdyne.com', '335-555-7890', 'Boston', 'Massachusetts', 'USA', '02101'),
    ('Weyland-Yutani Corp.', 'contact@weylandyutani.com', '827-555-2345', 'Seattle', 'Washington', 'USA', '98101'),
    ('Tyrell Corporation', 'info@tyrell.com', '268-555-6789', 'Miami', 'Florida', 'USA', '33101'),
    ('Wonka Industries', 'contact@wonka.com', '315-555-0123', 'Houston', 'Texas', 'USA', '77001'),
    ('Massive Dynamic', 'info@massivedynamic.com', '435-555-4567', 'Philadelphia', 'Pennsylvania', 'USA', '19101'),
    ('Virtucon', 'contact@virtucon.com', '987-555-8901', 'Atlanta', 'Georgia', 'USA', '30301');

-- insert 10 records into models table
insert into models (model_name, model_usage, model_feature, model_dependancy, model_pricing_id, model_category_id, model_organization_id, model_user_id)
values
    ('ImageRecognizer', 'Image classification and object detection', 'Convolutional neural networks', 'TensorFlow', 3, 4, 1, 1),
    ('SentimentAnalyzer', 'Sentiment analysis for text data', 'Natural language processing', 'NLTK', 2, 3, 2, 2),
    ('StockPredictor', 'Stock price prediction and forecasting', 'Time series analysis', 'scikit-learn', 5, 9, 3, 3),
    ('FraudDetector', 'Fraud detection in financial transactions', 'Anomaly detection algorithms', 'PyOD', 4, 10, 4, 4),
    ('RecommenderEngine', 'Personalized recommendations', 'Collaborative filtering', 'TensorRec', 1, 8, 5, 5),
    ('TranslationModel', 'Language translation', 'Sequence-to-sequence models', 'TensorFlow', 6, 3, 6, 6),
    ('TrafficPredictor', 'Traffic flow prediction and optimization', 'Time series forecasting', 'Prophet', 7, 9, 7, 7),
    ('VoiceAssistant', 'Voice-based virtual assistant', 'Speech recognition and synthesis', 'DeepSpeech', 8, 3, 8, 8),
    ('CreditScorer', 'Credit risk assessment', 'Machine learning for credit scoring', 'XGBoost', 9, 7, 9, 9),
    ('GameAI', 'AI agents for gaming', 'Reinforcement learning algorithms', 'Stable Baselines', 10, 5, 10, 10);

-- insert 10 records into evaluations table
insert into evaluations (eval_threshold, eval_goal)
values
    ('Accuracy > 95%', 'High precision and recall'),
    ('F1-score > 0.8', 'Balance precision and recall'),
    ('RMSE < 0.1', 'Low error in regression tasks'),
    ('AUC > 0.9', 'Good discrimination for classification'),
    ('MAE < 5', 'Low absolute error for forecasting'),
    ('Perplexity < 10', 'Good language model performance'),
    ('Pearson correlation > 0.7', 'Strong correlation with target variable'),
    ('Silhouette score > 0.5', 'Well-defined and separated clusters'),
    ('Precision > 0.8', 'High precision for positive class'),
    ('Recall > 0.9', 'High recall for positive class');

-- insert 10 records into model_user table
insert into model_user (rating_user_id, rating_model_id, rating_value, rating_comment, rating_source)
values
    (1, 1, 5, 'Excellent model!', 'Internal'), 
    (2, 2, 4, 'Good performance, but could be better.', 'External'), 
    (3, 3, 3, 'Average model, nothing special.', 'Internal'), 
    (4, 4, 5, 'Highly accurate and efficient.', 'External'), 
    (5, 5, 2, 'Needs improvement in certain areas.', 'Internal'),
    (6, 6, 4, 'Reliable and consistent performance.', 'External'), 
    (7, 7, 3, 'Could be more user-friendly.', 'Internal'), 
    (8, 8, 5, 'Exceeds expectations!', 'External'), 
    (9, 9, 4, 'Good value for money.', 'Internal'), 
    (10, 10, 3, 'Average rating, room for improvement.', 'External');

-- insert 10 records into model_eval_achievement table
insert into model_eval_achievement (eval_id, model_id, metric)
values
    (1, 1, 'Accuracy = 97%'),
    (2, 2, 'F1-score = 0.82'),
    (3, 3, 'RMSE = 0.08'),
    (4, 4, 'AUC = 0.92'),
    (5, 5, 'MAE = 3.5'),
    (6, 6, 'Perplexity = 8.2'),
    (7, 7, 'Pearson correlation = 0.75'),
    (8, 8, 'Silhouette score = 0.6'),
    (9, 9, 'Precision = 0.85'),
    (10, 10, 'Recall = 0.91');


go
-- Verify
-- Selecting all the tables we created
select * from users;
select * from categories;
select * from pricings;
select * from organizations;
select * from models;
select * from evaluations;
select * from model_user;
select * from model_eval_achievement;

-- Drop statement for the view
drop view if exists ModelsInfoView
GO

/*Creating a view to see all the models, their categories, pricingg, and evaluations for users*/
create view ModelsInfoView as
select
    m.model_name as model,
    m.model_usage as use,
    m.model_feature as features,
    c.category_name as category,
    p.pricing_charges as prices,
    ea.metric as metric,
    e.eval_goal as goal
from 
    models as m
join categories as c on c.category_id = m.model_category_id
join pricing as p on p.pricing_id = m.model_pricing_id
join model_eval_achievement as ea on ea.model_id = m.model_id
join evaluations as e on e.eval_id = ea.eval_id;
GO

-- Demonstration for the ModelsInfoView view
select * from ModelsInfoView
GO

-- Dropping procedure if we want to update it in future
if exists (select * from sys.objects where type = 'P' and name = 'InsertUsers')
begin
    drop procedure dbo.InsertUsers;
end
GO

-- Creating a procedure to insert a user's information
create procedure InsertUsers
    @FirstName nvarchar(50),
    @LastName nvarchar(50),
    @Email nvarchar(50),
    @Contact varchar(20),
    @City nvarchar(50),
    @Region nvarchar(50),
    @UserCountry nvarchar(50),
    @ZipCode varchar(20)
as
begin
    set nocount on;
    begin try
        begin transaction
        if exists (select 1 from users where user_email = @Email)
        begin 
            raiserror('Email Already Exists', 16, 1);
            return;
        end
        if len(@Contact) <> 10
        begin
            raiserror('Invalid Contact Number', 16, 1);
            return;
        end
        insert into users (user_firstname, user_lastname, user_email, user_contact, user_city, user_region, user_country, user_zipcode)
        values (@FirstName, @LastName, @Email, @Contact, @City, @Region, @UserCountry, @ZipCode)
        commit transaction;
    end try
    begin catch
        if @@trancount > 0
            rollback transaction;
        throw;
    end catch
end
GO

-- Dropping procedure if we want to update it in future
if exists (select * from sys.objects where type = 'P' and name = 'UpdateUsers')
begin
    drop procedure dbo.UpdateUsers;
end
GO

-- Creating a procedure to update a user's details
create procedure UpdateUsers
    @UserID int,
    @FirstName nvarchar(50),
    @LastName nvarchar(50),
    @Email nvarchar(50),
    @Contact varchar(20),
    @City nvarchar(50),
    @Region nvarchar(50),
    @UserCountry nvarchar(50),
    @ZipCode varchar(20)
as
begin
    set nocount on;
    begin try
        begin transaction
        if exists (select 1 from users where user_email = @Email and user_id <> @UserID)
        begin 
            raiserror('Email Already Exists for another user', 16, 1);
            return;
        end
        if len(@Contact) <> 10
        begin
            raiserror('Invalid Contact Number', 16, 1);
            return;
        end
        update users
        set user_firstname = @FirstName,
            user_lastname = @LastName,
            user_email = @Email,
            user_contact = @Contact,
            user_city = @City,
            user_region = @Region,
            user_country = @UserCountry,
            user_zipcode = @ZipCode
        where user_id = @UserID
        commit transaction;
    end try
    begin catch
        if @@trancount > 0
            rollback transaction;
        throw;
    end catch
end
GO

-- Dropping procedure if I want to update it in future
if exists (select * from sys.objects where type = 'P' and name = 'DeleteUsers')
begin
    drop procedure dbo.DeleteUsers;
end
GO

-- Creating a procedure to delete a user
create procedure DeleteUsers
    @UserID int
as
begin
    set nocount on;
    begin try
        begin transaction
        delete from users
        where user_id = @UserID;
        commit transaction;
    end try
    begin catch
        if @@trancount > 0
            rollback transaction;
        throw;
    end catch
end
GO