--PA para TCarga
-- author: Luis mikhail Palomino Paucar
use BDAcademico
go

---Listar carrera
if OBJECT_ID('spListarCarga') is not null
drop proc spListarCarga
go
create proc spListarCarga
as
begin
select IdCarga, CodDocente,CodAsignatura,Semestre from TCarga
end
go
--Consulta
execute spListarCarga
go


--PA para agregar Carga
if OBJECT_ID('spAgregarCarga') is not null
	drop proc spAgregarCarga
go
create proc spAgregarCarga

@IdCarga int, @CodDocente char(3),@CodAsignatura char(3), @Semestre varchar(20)
as
begin
	---validacion de parametro CodError=0(Correcto), CodError=1,(Error)
	---validar la clave primaria
	if not exists(select IdCarga from TCarga where IdCarga=@IdCarga)
	---validar que la asignatura no se duplique
		if exists(select CodAsignatura from TCarga where CodAsignatura=@CodAsignatura)
			if not exists(select Semestre from TCarga where Semestre=@Semestre)
			begin
				insert into TCarga values(@IdCarga,@CodDocente,@CodAsignatura,@Semestre)
				select CodError=0,Mensaje='Carga insertada en TCarga'
			end
			else select CodError = 1, Mensaje='Error: Carga Duplicada en el semestre en TCarga'
		else 
		begin
			insert into TCarga values(@IdCarga,@CodDocente,@CodAsignatura,@Semestre)
			select CodError=0,Mensaje='Carga insertada en TCarga'
		end
	else select CodError=1, Mensaje='Error: ID duplicada en TCarga'	
end 
go
--Probar el PA
execute spAgregarCarga '21','D02','S21','2020-II'
go


---Eliminar Carga
if OBJECT_ID('spEliminarCarga') is not null
drop proc spEliminarCarga
go
create proc spEliminarCarga
@IdCarga char(3)
as
begin
	--CodCarrera exista
	if exists(select IdCarga from TCarga where IdCarga=@IdCarga)
		begin
			delete from TCarga where IdCarga=@IdCarga
			select CodError=0, Mensaje='Error:Carga eliminada de TCarga'
		end
	else select CodError=1, Mensaje='Error:IdCarga no existe en TCarga'
end
go

execute spEliminarCarga '19'
go


--actualizar Carga
if OBJECT_ID('spActualizarCarga') is not null
drop proc spActualizarCarga
go

create proc spActualizarCarga
@IdCarga int, @CodDocente char(3),@CodAsignatura char(3), @Semestre varchar(20)
as
begin
	--validar que el Codigo de Carga exista
	if exists(select IdCarga from TCarga where IdCarga=@IdCarga)
		if not exists(select CodAsignatura from TCarga where CodAsignatura=@CodAsignatura)
		begin
			update TCarga set CodDocente=@CodDocente,CodAsignatura=@CodAsignatura, Semestre=@Semestre where IdCarga=@IdCarga
			select CodError=0, Mensaje='Carga actualizada en TCarga'
		end
		else select CodError=1, Mensaje='ERROR: Asignatura duplicada en TCarga'
	else select CodError=1, Mensaje='ERROR: Carga no existe en TCarga'
end
go
execute spActualizarCarga '17','D08','S22','2020-I'
go

--busqueda Carga

if OBJECT_ID('spBuscarrCarga') is not null
drop proc spBuscarCarga
go

create proc spBuscarCarga
@Texto varchar(50), @Criterio varchar(50)
as
begin
	If(@Criterio='IdCarga')
		select IdCarga, CodDocente,CodAsignatura,Semestre from TCarga where IdCarga=@Texto
	else if (@Criterio='CodDocente')
		select IdCarga, CodDocente,CodAsignatura,Semestre from TCarga where CodDocente=@Texto
	else if (@Criterio='CodAsignatura')
		select IdCarga, CodDocente,CodAsignatura,Semestre from TCarga where CodAsignatura=@Texto
	else if (@Criterio='Semestre')
		select IdCarga, CodDocente,CodAsignatura,Semestre from TCarga where Semestre=@Texto
end
go
--Probar PA
execute spBuscarCarga '2020-I','Semestre'
go
