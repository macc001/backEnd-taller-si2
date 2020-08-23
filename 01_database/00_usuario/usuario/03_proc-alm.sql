
CREATE OR REPLACE FUNCTION usuario.loginUsuario(_user varchar, _passw varchar) 
   RETURNS TABLE (
	ok bool,
	mensaje varchar,
    id_usuario int,
	username varchar,
	email varchar,
	foto varchar,
	nombre varchar,
	apellido varchar,
	telefono varchar,
    tipo char
) 
AS $$
DECLARE
	usuario int;
	passwor varchar;
BEGIN
    usuario:=(select usua.id_usuario from usuario.usuario usua where usua.username=$1 or usua.email=$1);
	if(usuario is null)then
		ok:=false;
		mensaje:='Usuario no se encuentra registrado';
		RETURN QUERY SELECT
			ok,mensaje,
			id_usuario,username,email,foto,nombre,apellido,telefono,tipo;
	else
		passwor:=(select usua.passwrd from usuario.usuario usua where usua.passwrd=$2 and usua.id_usuario=usuario);
		if(passwor is null)then
			ok:=false;
			mensaje:='Contraseña incorrecta';
			RETURN QUERY SELECT
				ok,mensaje,
				id_usuario,username,email,foto,nombre,apellido,telefono,tipo;
		else
			ok:=true;
			mensaje:='Datos correctos';
			RETURN QUERY SELECT
				ok::bool,mensaje::varchar,
				usua.id_usuario::int, 
				usua.username::varchar,
				usua.email::varchar,
				usua.urlfoto::varchar,
                pers.nombre::varchar,
				pers.apellido::varchar,
				pers.telefono::varchar,
				pers.tipo_persona::char
				from usuario.usuario usua, usuario.persona pers
                	where usua.id_usuario=pers.id_persona and (usua.username=$1 or usua.email=$1) and usua.passwrd=$2;			
		end if;
	end if;
END; $$ 
LANGUAGE 'plpgsql';

drop function usuario.loginUsuario(varchar,varchar);
select * from usuario.loginUsuario('macc','123');
select * from usuario.usuario;
select * from usuario.persona;


-- ---------------------------------------------------------
-- ---------------------GET---------------------------------

	
CREATE OR REPLACE FUNCTION usuario.getUsuario(indice smallint,cant smallint, userlog varchar) 
   RETURNS TABLE (
    id_usuario int,
	username varchar,
	email varchar,
	urlfoto varchar,
	estado boolean,
	id_persona int,
	nombre varchar,
	apellido varchar,
	telefono varchar,
	ci_nit varchar,
	direccion varchar,
	sexo char,
	tipo_pers char
) 
AS $$
BEGIN
    IF($3 ='-1')THEN
        RETURN QUERY SELECT
				usua.id_usuario::int, 
				usua.username::varchar,
				usua.email::varchar,
				usua.urlfoto::varchar,
				usua.estado::boolean,
				usua.id_persona::int,
				pers.nombre::varchar,
				pers.apellido::varchar,
				pers.telefono::varchar,
				pers.ci_nit::varchar,
				pers.dirreccion::varchar,
				pers.sexo::char,
				pers.tipo_persona::char
				from usuario.usuario usua, usuario.persona pers
					where usua.id_usuario=pers.id_persona
			order by pers.apellido asc
			OFFSET ($1*$2)-$2 LIMIT $2;
    ELSE
        RETURN QUERY SELECT 
				usua.id_usuario::int, 
				usua.username::varchar,
				usua.email::varchar,
				usua.urlfoto::varchar,
				usua.estado::boolean,
				usua.id_persona::int,
				pers.nombre::varchar,
				pers.apellido::varchar,
				pers.telefono::varchar,
				pers.ci_nit::varchar,
				pers.dirreccion::varchar,
				pers.sexo::char,
				pers.tipo_persona::char
				from usuario.usuario usua, usuario.persona pers
            where usua.id_usuario=pers.id_persona and 
			usua.username like concat('%',$3,'%') or pers.nombre like concat('%',$3,'%') or pers.apellido like concat('%',$3,'%')
			order by usua.username, pers.nombre, pers.apellido asc OFFSET ($1*$2)-$2 LIMIT $2;
    END IF;
END; $$ 
LANGUAGE 'plpgsql';

drop function usuario.getUsuario(smallint,smallint,varchar);
select * from usuario.getUsuario('1','5','-1');
select * from usuario.getUsuario('1','5','mil');



-- ---------------------INSERT---------------------------------


CREATE OR REPLACE FUNCTION usuario.insertUsuario(_username varchar, _email varchar, _password varchar, _urlfoto varchar,
	_estado boolean, _nombre varchar, _apellido varchar, _telefono int,
	 _ci int, _dirrecion varchar, _sexo char, _tipo_pers char) 
   RETURNS TABLE (
    ok boolean,
    mensaje varchar
) 
AS $$
DECLARE
	dniver varchar;
	nombrever varchar;
	emailver varchar;
	ultimo_id int;
BEGIN
	dniver:=(select pers.ci_nit from usuario.persona pers where pers.ci_nit=$9 limit 1);
	nombrever:=(select usua.username from usuario.usuario usua where usua.username=$1 limit 1);
	emailver:=(select usua.email from usuario.usuario usua where usua.email=$2 limit 1);
	-- raise notice 'dni: %  ',dniver;
	-- raise notice 'nombrever: %  ',nombrever;
	-- raise notice 'email: %  ',emailver;
	if(dniver is null) then
		if(nombrever is null) then
			if(emailver is null) then
				insert into usuario.persona values(default,$6,$7,$8,$9,$10,$11,'h',$12);
				ultimo_id := lastval();
				insert into usuario.usuario values(default,$1,$2,$3,$4,now(),$5,'0',ultimo_id);
				ok:=true;
				mensaje:='Usuario registrado correctamente';
				RETURN QUERY SELECT
					ok,mensaje;
			else
				ok:=false;
				mensaje:='Email ya se encuentra registrado, Ingrese otro email';
				RETURN QUERY SELECT
					ok,mensaje;
			end if;	
		else
			ok:=false;
			mensaje:='USUARIO ya se encuentra registrado, Ingrese otro usuario';
			RETURN QUERY SELECT
				ok,mensaje;
		end if;	
	else
		ok:=false;
		mensaje:='Persona con CI ya se encuentra registrado';
		RETURN QUERY SELECT
			ok,mensaje;
	end if;	
END; $$ 
LANGUAGE 'plpgsql';

drop function usuario.insertUsuario(varchar, varchar, varchar, varchar,
	 boolean, varchar, varchar, int, int, varchar, char, char);
select * from usuario.insertUsuario(
	'macc2','macc2@gmail.com','123',
	'https://img2.freepng.es/20180501/aiq/kisspng-computer-icons-mobile-phones-contact-free-clip-a-5ae89e0e46df20.5997647115251942542903.jpg',
	true, 'miguel jose',
	'damian ortiz', '-1', '9636772',
	'scz 4to anillo', 'm', 'p'
);

select now();
select * from usuario.usuario;
select * from usuario.persona;




-- ---------------------UPDATE---------------------------------


CREATE OR REPLACE FUNCTION usuario.updateUsuario(_username varchar, _email varchar, 
	_estado boolean, _nombre varchar, _apellido varchar, _telefono int,
	 _ci int, dirrecion varchar, sexo char) 
   RETURNS TABLE (
    ok boolean,
    mensaje varchar
) 
AS $$
DECLARE
	dniver varchar;
	nombrever varchar;
	emailver varchar;
	ultimo_id int;
BEGIN
	dniver:=(select pers.ci_nit from usuario.persona pers where pers.ci_nit=$9 limit 1);
	nombrever:=(select usua.username from usuario.usuario usua where usua.username=$1 limit 1);
	emailver:=(select usua.email from usuario.usuario usua where usua.email=$2 limit 1);
	-- raise notice 'dni: %  ',dniver;
	-- raise notice 'nombrever: %  ',nombrever;
	-- raise notice 'email: %  ',emailver;
	if(dniver is null) then
		if(nombrever is null) then
			if(emailver is null) then
				insert into usuario.persona values(default,$6,$7,$8,$9,$10,$11,'h',$12);
				ultimo_id := lastval();
				insert into usuario.usuario values(default,$1,$2,$3,$4,now(),$5,'0',ultimo_id);
				ok:=true;
				mensaje:='Usuario registrado correctamente';
				RETURN QUERY SELECT
					ok,mensaje;
			else
				ok:=false;
				mensaje:='Email ya se encuentra registrado, Ingrese otro email';
				RETURN QUERY SELECT
					ok,mensaje;
			end if;	
		else
			ok:=false;
			mensaje:='USUARIO ya se encuentra registrado, Ingrese otro usuario';
			RETURN QUERY SELECT
				ok,mensaje;
		end if;	
	else
		ok:=false;
		mensaje:='Persona con CI ya se encuentra registrado';
		RETURN QUERY SELECT
			ok,mensaje;
	end if;	
END; $$ 
LANGUAGE 'plpgsql';

drop function usuario.insertUsuario(varchar, varchar, varchar, varchar,
	 boolean, varchar, varchar, int, int, varchar, char, char);
select * from usuario.insertUsuario(
	'macc2','macc2@gmail.com','123',
	'https://img2.freepng.es/20180501/aiq/kisspng-computer-icons-mobile-phones-contact-free-clip-a-5ae89e0e46df20.5997647115251942542903.jpg',
	true, 'miguel jose',
	'damian ortiz', '-1', '9636772',
	'scz 4to anillo', 'm', 'p'
);


CREATE OR REPLACE FUNCTION usuarios.updateUsuario(_iduser int, _dni varchar, _userlogin varchar, _email varchar, _foto varchar,
	_dato json, _nombrecompleto varchar, _estado char, _tipo char) 
   RETURNS TABLE (
    ok boolean,
    mensaje varchar
) 
AS $$
DECLARE
	dniver smallint;
	nombrever smallint;
	emailver smallint;
BEGIN
	dniver:=(select count(usua.dni) from usuarios.usuario usua where usua.dni=$2 and usua.id_usuario!=$1);
	nombrever:=(select count(usua.userlogin) from usuarios.usuario usua where usua.userlogin=$3 and usua.id_usuario!=$1);
	emailver:=(select count(usua.email) from usuarios.usuario usua where usua.email=$4 and usua.id_usuario!=$1);
	raise notice 'dni: %  ',dniver;
	raise notice 'nombrever: %  ',nombrever;
	raise notice 'email: %  ',emailver;
	if(dniver>0) then
		ok:=false;
		mensaje:='DNI ya se encuentra registrado';
		RETURN QUERY SELECT
			ok,mensaje;
	else
		if(nombrever>0) then
			ok:=false;
			mensaje:='USUARIO ya se encuentra registrado, Ingrese otro usuario';
			RETURN QUERY SELECT
				ok,mensaje;
		else
			if(emailver>0) then
				ok:=false;
				mensaje:='Email ya se encuentra registrado, Ingrese otro email';
				RETURN QUERY SELECT
					ok,mensaje;
			else
				update usuarios.usuario set dni=$2, userlogin=$3, email=$4, foto=$5,
					dato=$6, nombrecompleto=$7, estado=$8, tipo=$9 
					where id_usuario=$1;
				ok:=true;
				mensaje:='Usuario actualizado correctamente';
				RETURN QUERY SELECT
					ok,mensaje;
			end if;	
		end if;
	end if;	
END; $$ 
LANGUAGE 'plpgsql';

drop function usuarios.updateUsuario(int, varchar, varchar, varchar, varchar, json, varchar, char, char);
select * from usuarios.updateUsuario('4','1234567','admin','admin@gmail.com',
		'https://png.pngtree.com/element_our/png/20181206/users-vector-icon-png_260862.jpg',
		'[{"telefono":["65289079"]}]','admin admin','a','a');

select * from usuarios.usuario;
select * from usuarios.admin;


-- ---------------------DELETE---------------------------------


CREATE OR REPLACE FUNCTION usuario.deleteUsuario(id_user int) 
   RETURNS TABLE (
    ok boolean,
    mensaje varchar
) 
AS $$
DECLARE
	id_edit int;
	id_pers int;
BEGIN	
	id_edit:=(select usua.id_usuario from usuario.usuario usua where usua.id_usuario=$1 limit 1);
	if(id_edit is null) then		
		ok:=false;
		mensaje:='Usuario no existe';
		RETURN QUERY SELECT
			ok,mensaje;
	else
		ok:=true;
		mensaje:='Usuario Eliminardo correctamente';
		id_pers:=(select usua.id_persona from usuario.usuario usua where usua.id_usuario=$1 limit 1);
		delete from usuario.usuario usua where usua.id_usuario=$1;
		delete from usuario.persona pers where pers.id_persona=id_pers;
		RETURN QUERY SELECT
			ok,mensaje;
	end if;
END; $$ 
LANGUAGE 'plpgsql';


drop function usuario.deleteUsuario(int);
select * from usuario.deleteUsuario('5');

select * from usuario.insertUsuario(
	'macc2','macc2@gmail.com','123',
	'https://img2.freepng.es/20180501/aiq/kisspng-computer-icons-mobile-phones-contact-free-clip-a-5ae89e0e46df20.5997647115251942542903.jpg',
	true, 'miguel jose',
	'damian ortiz', '-1', '9636772',
	'scz 4to anillo', 'm', 'p'
);

select * from usuario.usuario;
select * from usuario.persona;
