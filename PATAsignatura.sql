--PA para TCarrera
--Maricarmen DIAZ CHAVEZ
---17/2/20
use BDAcademico
go

---Listar Asignatura
if OBJECT_ID('spListarAsignatura') is not null
drop proc spListarAsignatura
go
create proc spListarAsignatura
as
begin
select CodAsignatura, Asignatura, CodRequisito from TAsignatura
end
go
--Consulta
execute spListarAsignatura
go


--PA para agregar Asignatura
if OBJECT_ID('spAgregarAsignatura') is not null
	drop proc spAgregarAsignatura
go
create proc spAgregarAsignatura

@CodAsignatura char(3), @Asignatura varchar(50), @CodRequisito char(3)
as
begin
	---validacion de parametro CodError=0(Correcto), CodError=1,(Error)
	---validar la clave primaria
	if not exists(select CodAsignatura from TAsignatura where CodAsignatura=@CodAsignatura)
	---validar que la Asignatura no se duplique
		if not exists(select Asignatura from TAsignatura where Asignatura=@Asignatura)
		begin
			insert into TAsignatura values(@CodAsignatura,@Asignatura, @CodRequisito)
			select CodError=0,Mensaje='Asignatura insertada en TAsignatura'
		end
		else select CodError = 1, Mensaje='Error: Clave Duplicada en TAsignatura'
	else select CodError=1, Mensaje='Error: Clave duplicada en TAsignatura'
end 
go
--Probar el PA
execute spAgregarAsignatura 'S22','quechua','S21'
go


---Eliminar Asignatura
if OBJECT_ID('spEliminarAsignatura') is not null
drop proc spEliminarAsignatura
go
create proc spEliminarAsignatura
@CodAsignatura varchar(50)
as
begin
	--Usuario exista
	if exists(select CodAsignatura from TAsignatura where CodAsignatura=@CodAsignatura)
	--Usuario no este en la tabla Docente
		if not exists(select CodAsignatura from TCarga where CodAsignatura=@CodAsignatura)
		--Usuario no este en la tabla Alumno
			if not exists(select CodAsignatura from TNotas where CodAsignatura=@CodAsignatura) 
			begin
				delete from TAsignatura where CodAsignatura=@CodAsignatura
				select CodError=0, Mensaje='Error:Asignatura eliminada de TAsignatura'
			end
			else select CodError=1, Mensaje='Error:Asignatura existe en TNotas'
		else select CodError=1, Mensaje='Error:Asignatura existe en TCarga'
	else select CodError=1, Mensaje='Error:Asignatura no existe en TAsignatura'
end
go
--probar el PA
execute spEliminarAsignatura 'S22'
go


--actualizar Usuario
if OBJECT_ID('spActualizarAsignatura') is not null
drop proc spActualizarAsignatura
go

create proc spActualizarAsignatura
@CodAsignatura char(3), @Asignatura varchar(50),@CodRequisito char(3)
as
begin
	--validar que la Asignatura que exista
	if exists(select CodAsignatura from TAsignatura where CodAsignatura=@CodAsignatura)
		if not exists(select @Asignatura from TAsignatura where Asignatura=@Asignatura)
		begin
			update TAsignatura set Asignatura=@Asignatura, CodRequisito=@CodRequisito where CodAsignatura=@CodAsignatura
			select CodError=0, Mensaje='Asignatura actualizada en TAsignatura'
		end
		else select CodError=1, Mensaje='ERROR: Asignatura duplicada en TAsignatura'
	else select CodError=1, Mensaje='ERROR: Asignatura no existe en TAsignatura'
end
go
--probar PA
execute spActualizarAsignatura 'S22','quechua2','S02'
go


--busqueda Asignatura 

if OBJECT_ID('spBuscarAsignatura ') is not null
drop proc spBuscarAsignatura 
go

create proc spBuscarAsignatura 
@Texto varchar(50), @Criterio varchar(50)
as
begin
	If(@Criterio='CodAsignatura ')
		select CodAsignatura , Asignatura , CodRequisito from TAsignatura where CodAsignatura=@Texto
	else if (@Criterio='Asignatura')
		select CodAsignatura , Asignatura , CodRequisito from TAsignatura where Asignatura=@Texto
			else if (@Criterio='Requisito')
				select CodAsignatura , Asignatura , CodRequisito from TAsignatura where CodRequisito=@Texto
end
go
--probar PA
execute spBuscarAsignatura 'S01','Requisito'
go



