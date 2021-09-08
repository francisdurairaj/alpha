=======================================================================
What is Redshift ?
=======================================================================
  - AWS Redshift, Data ware-house service offering from AWS Cloud
  - Fast and powerful, fully managed, petabyte-scale service
  - Manages the work needed to set up, operate, and scale a data warehouse
  - You can automate administrative tasks such as backups, and patching
  - Automatically monitors your nodes and drives to help you recover from failure

=======================================================================
CREATION OF CLUSTER ON REDSHIFT
=======================================================================
IAM Redshift Role ARN :   arn:aws:iam::932589472370:role/redshiftAdmin-Role
Redshift Cluster Name :   sigma-ssad-redshiftcluster
Database Name         :   ssaddb-sigma-ssad-redshiftcluster
MasterUserName        :   ssaddb-sigma-ssad-redshiftcluster-awsuser

=======================================================================
CREATION OF TABLES IN REDSHIFT CLUSTER DB
=======================================================================
create table users(
			userid integer not null distkey sortkey,
			username char(8),
			firstname varchar(30),
			lastname varchar(30),
			city varchar(30),
			state char(2),
			email varchar(100),
			phone char(14),
			likesports boolean,
			liketheatre boolean,
			likeconcerts boolean,
			likejazz boolean,
			likeclassical boolean,
			likeopera boolean,
			likerock boolean,
			likevegas boolean,
			likebroadway boolean,
			likemusicals boolean);

create table venue(
			venueid smallint not null distkey sortkey,
			venuename varchar(100),
			venuecity varchar(30),
			venuestate char(2),
			venueseats integer);

 create table category(
			catid smallint not null distkey sortkey,
			catgroup varchar(10),
			catname varchar(10),
			catdesc varchar(50));

 create table date(
			dateid smallint not null distkey sortkey,
			caldate date not null,
			day character(3) not null,
			week smallint not null,
			month character(5) not null,
			qtr character(5) not null,
			year smallint not null,
			holiday boolean default('N'));

 create table event(
        	eventid integer not null distkey,
        	venueid smallint not null,
        	catid smallint not null,
        	dateid smallint not null sortkey,
        	eventname varchar(200),
        	starttime timestamp);

create table listing(
          	listid integer not null distkey,
          	sellerid integer not null,
          	eventid integer not null,
          	dateid smallint not null  sortkey,
          	numtickets smallint not null,
          	priceperticket decimal(8,2),
          	totalprice decimal(8,2),
          	listtime timestamp);

create table sales(
			salesid integer not null,
			listid integer not null distkey,
			sellerid integer not null,
			buyerid integer not null,
			eventid integer not null,
			dateid smallint not null sortkey,
			qtysold smallint not null,
			pricepaid decimal(8,2),
			commission decimal(8,2),
			saletime timestamp);

=======================================================================
INSERTION OF DATA TO REDSHIFT CLUSTER DB TABLES
=======================================================================
Sample COPY Command:
copy users from 's3://<myBucket>/tickit/allusers_pipe.txt'
credentials 'aws_iam_role=<iam-role-arn>'
delimiter '|' region '<aws-region>';

copy users from 's3://app-ion-dev-bucket-us-east-2/tickitdb/allusers_pipe.txt'
credentials 'aws_iam_role=arn:aws:iam::932589472370:role/redshiftAdmin-Role'
delimiter '|' region 'us-east-2';

copy venue from 's3://app-ion-dev-bucket-us-east-2/tickitdb/venue_pipe.txt'
credentials 'aws_iam_role=arn:aws:iam::932589472370:role/redshiftAdmin-Role'
delimiter '|' region 'us-east-2';

copy category from 's3://app-ion-dev-bucket-us-east-2/tickitdb/category_pipe.txt'
credentials 'aws_iam_role=arn:aws:iam::932589472370:role/redshiftAdmin-Role'
delimiter '|' region 'us-east-2';

copy date from 's3://app-ion-dev-bucket-us-east-2/tickitdb/date2008_pipe.txt'
credentials 'aws_iam_role=arn:aws:iam::932589472370:role/redshiftAdmin-Role'
delimiter '|' region 'us-east-2';

copy event  from 's3://app-ion-dev-bucket-us-east-2/tickitdb/allevents_pipe.txt'
credentials 'aws_iam_role=arn:aws:iam::932589472370:role/redshiftAdmin-Role'
delimiter '|' timeformat 'YYYY-MM-DD HH:MI:SS' region 'us-east-2';

copy listing  from 's3://app-ion-dev-bucket-us-east-2/tickitdb/listings_pipe.txt'
credentials 'aws_iam_role=arn:aws:iam::932589472370:role/redshiftAdmin-Role'
delimiter '|' region 'us-east-2';

copy sales from 's3://app-ion-dev-bucket-us-east-2/tickitdb/sales_tab.txt'
credentials 'aws_iam_role=arn:aws:iam::932589472370:role/redshiftAdmin-Role'
delimiter '\t' timeformat 'MM/DD/YYYY HH:MI:SS' region 'us-east-2';

=======================================================================
RUNNING OF SAMPLE QUERIES ON REDSHIFT CLUSTER DB TABLES
=======================================================================
-- Get definition for the sales table.
SELECT *
FROM pg_table_def
WHERE tablename = 'sales';

-- Find total sales on a given calendar date.
SELECT sum(qtysold)
FROM   sales, date
WHERE  sales.dateid = date.dateid
AND    caldate = '2008-01-05';

-- Find top 10 buyers by quantity.
SELECT firstname, lastname, total_quantity
FROM   (SELECT buyerid, sum(qtysold) total_quantity
        FROM  sales
        GROUP BY buyerid
        ORDER BY total_quantity desc limit 10) Q, users
WHERE Q.buyerid = userid
ORDER BY Q.total_quantity desc;

-- Find events in the 99.9 percentile in terms of all time gross sales.
SELECT eventname, total_price
FROM  (SELECT eventid, total_price, ntile(1000) over(order by total_price desc) as percentile
       FROM (SELECT eventid, sum(pricepaid) total_price
             FROM   sales
             GROUP BY eventid)) Q, event E
       WHERE Q.eventid = E.eventid
       AND percentile = 1
ORDER BY total_price desc;
