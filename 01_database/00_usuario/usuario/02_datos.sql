select now();
select current_date;
-- manejo de fechas https://www.postgresql.org/docs/8.2/functions-datetime.html
-- https://www.postgresqltutorial.com/postgresql-now/

insert into usuario.persona(
     id_persona,nombre,apellido,telefono,ci_nit,dirreccion,sexo,estado,tipo_persona
)
values (default, 'miguel','carvjal','78526863','9636771','santa cruz','m','h','p'),
(default, 'gary','cruz','78526863','9525444','santa cruz, montero','m','h','p'),
(default, 'milena','molinedo','78565263','9652355','cochabamba','f','h','a'),
(default, 'link','franco','78545663','4524785','santa cruz','m','h','c');
-- select * from usuario.persona;
-- delete from usuario.persona;

-- ----------------------------------------------------------------------

insert into usuario.usuario(
     id_usuario,username,email,passwrd,urlfoto,fecha_creacion,estado,cant_intentos,id_persona
)
values (default, 'macc','macc@gmail.com','123','https://img2.freepng.es/20180501/aiq/kisspng-computer-icons-mobile-phones-contact-free-clip-a-5ae89e0e46df20.5997647115251942542903.jpg','2020/08/22',true,0,1),
 (default, 'gary','gary@gmail.com','123','https://i0.pngocean.com/files/210/26/514/computer-icons-user-male-clip-art-faces.jpg','2020/08/22',true,0,2),
 (default, 'mile','mile@gmail.com','123','https://img2.freepng.es/20180501/aiq/kisspng-computer-icons-mobile-phones-contact-free-clip-a-5ae89e0e46df20.5997647115251942542903.jpg','2020/08/22',true,0,3),
 (default, 'lino','lino@gmail.com','123','https://img2.freepng.es/20180501/aiq/kisspng-computer-icons-mobile-phones-contact-free-clip-a-5ae89e0e46df20.5997647115251942542903.jpg','2020/08/22',true,0,4);
-- select * from usuario.usuario;

 select * from usuario.usuario;
 select * from usuario.persona;
-- delete from usuario.usuario;

