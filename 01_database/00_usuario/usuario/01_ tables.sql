
drop table if exists usuario.persona;
create table usuario.persona
(
	id_persona serial not null,
	nombre varchar not null,
	apellido varchar not null,
	telefono int not null,
	ci_nit int not null,
	direccion varchar not null,
	sexo char not null,
	estado char not null,
	tipo_persona char,
	primary key(id_persona)
);

drop table if exists usuario.usuario;
create table usuario.usuario
(
	id_usuario serial not null,
	username varchar not null,
	email varchar not null,
	passwrd varchar not null,
	urlfoto varchar not null,
	fecha_creacion date not null,
	estado boolean not null,
	cant_intentos smallint not null,
	id_persona int not null,
	primary key(id_usuario),
	foreign key(id_persona) REFERENCES usuario.persona(id_persona)
	on delete no action on update no action
);
