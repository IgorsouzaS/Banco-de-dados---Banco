create database bank;
use bank;

create table banco(
codigo int,
nome varchar(25) not null,
unique (nome),
primary key(codigo)
);

create table agencia(
cod_banco int default null,
numero_agencia int not null,
endereco varchar(40) not null,
primary key(numero_agencia),
constraint fk_banco foreign key(cod_banco) references banco(codigo)
on delete cascade on update cascade);


create table conta(
numero_conta char(7) not null,
saldo decimal(10,2) not null,
tipo_conta smallint not null,
num_agencia int,
primary key(numero_conta),
foreign key(num_agencia) references agencia(numero_agencia)
on delete cascade on update cascade
);

create table cliente(
cpf char(14) not null,
nome varchar(20) not null,
sexo char(1) not null,
endereco varchar(40),
primary key(cpf)
);

create table historico(
cpf_cliente char(14) not null,
num_conta char(7) not null,
data_inicio date not null,
primary key(cpf_cliente, num_conta),
foreign key(cpf_cliente) references cliente(cpf)
on delete cascade on update cascade,
foreign key(num_conta) references conta(numero_conta)
on delete cascade on update cascade
);

create table telefone_cliente(
cpf_cli char(14) not null,
telefone_cli char(13) not null,
primary key(telefone_cli, cpf_cli),
foreign key(cpf_cli) references cliente(cpf)
on delete cascade on update cascade
);

insert into banco(codigo, nome) values (1, "Banco do Brasil"), (4, "CEF");

insert into agencia(numero_agencia, endereco, cod_banco) values (3153, 'Av. Marcelino Pires, 1960', 1);

select * from agencia;

insert into cliente(cpf, nome, sexo, endereco) values ('111.222.333-44', 'Jennifer B Souza', 'F', 'Rua Cuiabá, 1050'), 
('666.777.888-99', 'Caetano Lima', 'M', 'Rua Ivinhema, 879'), 
('555.444.777-33', 'Silvia Macedo', 'F', 'Rua Estados Unidos, 735');

INSERT INTO telefone_cliente values ('111.222.333-44', '(67)3422-7788'), 
('666.777.888-99', '(67)3423-9900'), ('666.777.888-99','(67)8121-8833');

alter table cliente add column email varchar(25);

select c.cpf, c.endereco from cliente c where c.nome like'%Paulo A Lima%';

select a.numero_agencia, a.endereco from agencia a where a.cod_banco = (select b.codigo from banco b where b.nome like '%Brasil%');

select c.nome as 'Nome Cliente', h.num_conta as 'Numero Conta', co.num_agencia as 'Numero agência'
from cliente c inner join historico h on h.cpf_cliente = c.cpf
inner join conta co on co.numero_conta = h.num_conta group by c.nome;

select * from cliente where sexo like '%M%';

select a.*, b.* from agencia a, banco b where b.codigo = a.cod_banco and a.numero_agencia = (select numero_agencia from agencia where numero_agencia = 0562);

select * from banco, agencia where codigo = cod_banco and numero_agencia = 0562;

delete from conta where numero_conta = '86340-2';

update agencia set numero_agencia = 6342 where numero_agencia = 0562;

update cliente set email = 'caetanolima@gmail.com' where cpf like '666.777.888-99';

update conta set saldo = saldo + (saldo * 1.1) where numero_conta like '23584-7';

select * from conta group by numero_conta;

select c.nome from cliente c inner join telefone_cliente t
on t.cpf_cli = c.cpf group by c.nome;

create view vDADOS_BANCARIOS as select c.nome as Nome, 
co.numero_conta as 'Numero Conta', co.saldo as Saldo
from cliente c inner join historico h on h.cpf_cliente = c.cpf
inner join conta co on co.numero_conta = h.num_conta group by c.nome;

SELECT * FROM bank.vdados_bancarios;
