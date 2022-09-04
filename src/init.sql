create table domains (domain text not null, check(domain <> ''));
.mode tab
.import dist/com.names domains
create index domain_index on domains(domain);
