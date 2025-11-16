create table
    refugi as
select
    *
from
    read_json ('./data/interim/*.json');