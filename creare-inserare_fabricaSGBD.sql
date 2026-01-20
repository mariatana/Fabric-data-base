--crearea tabelelor
create table transportator(
    id_transportator number(5) constraint pk_transportator primary key,
    email varchar2(100) constraint uq_transportator_email unique,
    telefon varchar2(20) constraint uq_transportator_telefon unique,
    adresa varchar2(200) not null,
    numar_mijloace number(10)  constraint chk_numar_mijloace check (numar_mijloace >=0),
    nume_firma varchar2(100) not null
);

create table discount(
    id_discount number(5) constraint pk_discount primary key,
    procent number(5) constraint chk_procent_valoare check(procent between 0 and 100)
);

create table client(
    id_client number(5) constraint pk_client primary key,
    nume varchar2(30) not null,
    prenume varchar2(30) not null,
    tip varchar2(20) constraint  chk_client_tip check(tip in ('ONG', 'PF')),
    email varchar2(100) constraint uq_client_email unique
);

create table departament(
    id_departament number(5) constraint pk_departament primary key,
    denumire varchar2(50) constraint uq_dept_denumire unique,
    locatie varchar2(50) not null,
    capacitate number(5) constraint chk_dept_capacitate check (capacitate > 0)
    
);
create table materie_prima(
    id_materie number(5)  constraint pk_materie primary key,
    tip_material varchar2(50) not null,
    temperatura_maxima number(5,2),
    densitate number(10,3) constraint chk_densitate_pozitiva check (densitate > 0)
);
CREATE TABLE furnizor (
    id_furnizor number(5)  constraint pk_furnizor primary key,
    nume_furnizor varchar2(100) not null,
    adresa varchar2(200),
    email varchar2(100) constraint uq_furnizor_email unique
);

CREATE TABLE angajat (
    id_angajat NUMBER(5) CONSTRAINT pk_angajat PRIMARY KEY,
    id_departament NUMBER(5) CONSTRAINT fk_angajat_dept REFERENCES departament(id_departament),
    nume VARCHAR2(30) NOT NULL,
    prenume VARCHAR2(30) NOT NULL,
    varsta NUMBER(2) CONSTRAINT chk_angajat_varsta CHECK (varsta >= 18),
    vechime NUMBER(2) not null
);

alter table angajat add id_linie number(5);
alter table angajat add constraint fk_angajat_linie 
foreign key (id_linie) references linie_productie(id_linie);

CREATE TABLE mijloc_de_transport (
    id_mijloc NUMBER(5) CONSTRAINT pk_mijloc PRIMARY KEY,
    id_transportator NUMBER(5) CONSTRAINT fk_mijloc_transp REFERENCES transportator(id_transportator),
    marca VARCHAR2(50),
    tonaj_maxim NUMBER(10,2) CONSTRAINT chk_tonaj CHECK (tonaj_maxim > 0),
    numar_immatriculare VARCHAR2(20) NOT NULL CONSTRAINT uq_nr_inmatriculare UNIQUE
);
CREATE TABLE linie_productie (
    id_linie NUMBER(5) CONSTRAINT pk_linie PRIMARY KEY,
    id_materie NUMBER(5) CONSTRAINT fk_linie_materie REFERENCES materie_prima(id_materie),
    productie_medie NUMBER(10),
    capacitate_maxima NUMBER(10) CONSTRAINT chk_capacitate_linie CHECK (capacitate_maxima > 0)
);

CREATE TABLE factura (
    id_factura NUMBER(5) CONSTRAINT pk_factura PRIMARY KEY,
    id_materie NUMBER(5) CONSTRAINT fk_factura_materie REFERENCES materie_prima(id_materie),
    id_furnizor NUMBER(5) CONSTRAINT fk_factura_furnizor REFERENCES furnizor(id_furnizor),
    pret NUMBER(10, 2) CONSTRAINT chk_factura_pret CHECK (pret > 0),
    cantitate NUMBER(10) CONSTRAINT chk_factura_cantitate CHECK (cantitate > 0),
    data_factura DATE DEFAULT SYSDATE,
    ora VARCHAR2(10)
);
CREATE TABLE jucarie (
    id_jucarie NUMBER(5) CONSTRAINT pk_jucarie PRIMARY KEY,
    id_linie NUMBER(5) CONSTRAINT fk_jucarie_linie REFERENCES linie_productie(id_linie),
    denumire VARCHAR2(100) NOT NULL,
    marime VARCHAR2(20) CONSTRAINT chk_jucarie_marime CHECK (marime IN ('Mica', 'Medie', 'Mare')),
    varsta_recomandata NUMBER(2) CONSTRAINT chk_jucarie_varsta CHECK (varsta_recomandata >= 0)
);
CREATE TABLE comanda (
    id_comanda NUMBER(5) CONSTRAINT pk_comanda PRIMARY KEY,
    id_client NUMBER(5) CONSTRAINT fk_comanda_client REFERENCES client(id_client),
    id_discount NUMBER(5) CONSTRAINT fk_comanda_discount REFERENCES discount(id_discount),
    id_mijloc NUMBER(5) CONSTRAINT fk_comanda_mijloc REFERENCES mijloc_de_transport(id_mijloc),
    pret_total NUMBER(10, 2) CONSTRAINT chk_comanda_pret CHECK (pret_total >= 0),
    metoda_plata VARCHAR2(20) CONSTRAINT chk_plata CHECK (metoda_plata IN ('Cash', 'Card', 'Transfer'))
);
CREATE TABLE detaliu (
    id_detaliu NUMBER(5) CONSTRAINT pk_detaliu PRIMARY KEY,
    id_comanda NUMBER(5) CONSTRAINT fk_detaliu_comanda REFERENCES comanda(id_comanda),
    id_jucarie NUMBER(5) CONSTRAINT fk_detaliu_jucarie REFERENCES jucarie(id_jucarie),
    cantitate NUMBER(5) CONSTRAINT chk_detaliu_cantitate CHECK (cantitate > 0),
    data_detaliu DATE not null,
    ora_detaliu VARCHAR(10) not null
);
--ALTER USER C##FABRICA_DE_JUCARII QUOTA UNLIMITED ON USERS;
--inserari
SELECT user FROM dual;
INSERT INTO transportator VALUES (1, 'contact@fastship.ro', '0722111222', 'Str. Logisticii 1, Bucuresti', 10, 'FastShip SRL');
INSERT INTO transportator VALUES (2, 'office@transgigi.ro', '0744333444', 'Bd. Transportului 5, Cluj', 5, 'Gigi Trans Express');
INSERT INTO transportator VALUES (3, 'info@toycarry.com', '0215556667', 'Sos. Industriala 10, Ilfov', 15, 'ToyCarry Logistic');
INSERT INTO transportator VALUES (4, 'delivery@rapid.ro', '0755888999', 'Str. Vitezei 3, Iasi', 8, 'Rapid Delivery');
INSERT INTO transportator VALUES (5, 'cargo@safe.ro', '0314445556', 'Calea Aradului 20, Timisoara', 12, 'Safe Cargo');

INSERT INTO discount VALUES (1, 15);
INSERT INTO discount VALUES (2, 20);
INSERT INTO discount VALUES (3, 10);
INSERT INTO discount VALUES (4, 5);
INSERT INTO discount VALUES (5, 30);

INSERT INTO client VALUES (1, 'Popescu', 'Ion', 'PF', 'ion.popescu@email.com');
INSERT INTO client VALUES (2, 'Salvati Copiii', 'Asociatia', 'ONG', 'contact@salvaticopiii.ro');
INSERT INTO client VALUES (3, 'Ionescu', 'Maria', 'PF', 'maria.ionescu@email.com');
INSERT INTO client VALUES (4, 'Zambet de Copil', 'Fundatia', 'ONG', 'office@zambet.org');
INSERT INTO client VALUES (5, 'Georgescu', 'Andrei', 'PF', 'andrei.g@email.com');
INSERT INTO client VALUES (6, 'Popescu', 'Maria', 'PF', 'maria.popescu@email.com');
commit;
INSERT INTO departament VALUES (1, 'Productie', 'Hala A', 50);
INSERT INTO departament VALUES (2, 'Logistica', 'Depozit Central', 20);
INSERT INTO departament VALUES (3, 'Resurse Umane', 'Cladire Administrativa', 5);
INSERT INTO departament VALUES (4, 'Control Calitate', 'Laborator 1', 10);
INSERT INTO departament VALUES (5, 'Vanzari', 'Birouri Etaj 1', 15);

INSERT INTO materie_prima VALUES (1, 'Plastic Reciclat', 40.5, 0.95);
INSERT INTO materie_prima VALUES (2, 'Lemn de Brad', 30.0, 0.55);
INSERT INTO materie_prima VALUES (3, 'Vopsea Non-Toxica', 25.0, 1.20);
INSERT INTO materie_prima VALUES (4, 'Bumbac Organic', 35.0, 0.15);
INSERT INTO materie_prima VALUES (5, 'Otel Inoxidabil', 100.0, 7.85);

INSERT INTO furnizor VALUES (1, 'EcoMaterials SRL', 'Str. Verzi 4, Brasov', 'comenzi@ecomat.ro');
INSERT INTO furnizor VALUES (2, 'WoodSupply SA', 'Sos. Padurii 1, Suceava', 'office@woodsupply.ro');
INSERT INTO furnizor VALUES (3, 'ColorWorld SRL', 'Str. Curcubeului 9, Ploiesti', 'sales@colorworld.ro');
INSERT INTO furnizor VALUES (4, 'Textile Prim', 'Bd. Tesaturii 12, Iasi', 'contact@textileprim.ro');
INSERT INTO furnizor VALUES (5, 'MetalTech', 'Calea Otelului 55, Galati', 'info@metaltech.ro');

INSERT INTO angajat VALUES (1, 1, 'Andrei', 'Mihai', 30, 5);
INSERT INTO angajat VALUES (2, 1, 'Enache', 'Ana', 25, 2);
INSERT INTO angajat VALUES (3, 3, 'Luca', 'George', 40, 12);
INSERT INTO angajat VALUES (4, 4, 'Radu', 'Elena', 35, 8);
INSERT INTO angajat VALUES (5, 2, 'Miron', 'Cristian', 28, 3);
INSERT INTO angajat VALUES (6, 2, 'Popescu', 'Maria', 28, 1, 1); 
INSERT INTO angajat VALUES (7, 2, 'Danescu', 'Ana', 28, 10, 4); 
commit;
update angajat set id_linie = 1 where id_angajat = 1;
update angajat set id_linie = 4 where id_angajat = 2;
update angajat set id_linie = 2 where id_angajat = 3;
update angajat set id_linie = 3 where id_angajat = 4;
update angajat set id_linie = 5 where id_angajat = 5;

INSERT INTO mijloc_de_transport VALUES (1, 1, 'Mercedes Sprinter', 3.5, 'B-101-FST');
INSERT INTO mijloc_de_transport VALUES (2, 2, 'Dacia Dokker', 0.8, 'CJ-20-CGO');
INSERT INTO mijloc_de_transport VALUES (3, 3, 'Volvo FH16', 24.0, 'B-555-TOY');
INSERT INTO mijloc_de_transport VALUES (4, 4, 'Ford Transit', 2.0, 'TM-99-DLY');
INSERT INTO mijloc_de_transport VALUES (5, 5, 'Renault Master', 3.0, 'BV-07-SAF');

INSERT INTO linie_productie VALUES (1, 1, 500, 1000);
INSERT INTO linie_productie VALUES (2, 2, 200, 400);
INSERT INTO linie_productie VALUES (3, 4, 300, 600);
INSERT INTO linie_productie VALUES (4, 1, 400, 800);
INSERT INTO linie_productie VALUES (5, 5, 150, 300);

INSERT INTO factura (id_factura, id_materie, id_furnizor, pret, cantitate, data_factura, ora) 
VALUES (1, 1, 1, 1500.50, 100, SYSDATE, '09:00');
INSERT INTO factura (id_factura, id_materie, id_furnizor, pret, cantitate, data_factura, ora) 
VALUES (2, 2, 2, 3200.00, 50, SYSDATE-5, '10:30');
INSERT INTO factura (id_factura, id_materie, id_furnizor, pret, cantitate, data_factura, ora) 
VALUES (3, 3, 3, 850.75, 20, SYSDATE-2, '14:20');
INSERT INTO factura (id_factura, id_materie, id_furnizor, pret, cantitate, data_factura, ora) 
VALUES (4, 4, 4, 2100.00, 200, SYSDATE-10, '11:15');
INSERT INTO factura (id_factura, id_materie, id_furnizor, pret, cantitate, data_factura, ora) 
VALUES (5, 5, 5, 9000.00, 10, SYSDATE-1, '16:45');
INSERT INTO factura (id_factura, id_materie, id_furnizor, pret, cantitate, data_factura, ora) 
VALUES (6, 1, 2, 4500.00, 90, SYSDATE-3, '08:30');
INSERT INTO factura (id_factura, id_materie, id_furnizor, pret, cantitate, data_factura, ora) 
VALUES (7, 3, 1, 1100.00, 15, SYSDATE-7, '11:45');
INSERT INTO factura (id_factura, id_materie, id_furnizor, pret, cantitate, data_factura, ora) 
VALUES (8, 5, 5, 12000.00, 15, SYSDATE-12, '09:15');
INSERT INTO factura (id_factura, id_materie, id_furnizor, pret, cantitate, data_factura, ora) 
VALUES (9, 2, 3, 2200.00, 40, SYSDATE-15, '13:20');
INSERT INTO factura (id_factura, id_materie, id_furnizor, pret, cantitate, data_factura, ora) 
VALUES (10, 4, 1, 3000.00, 180, SYSDATE-20, '10:00');

INSERT INTO jucarie VALUES (1, 1, 'Masinuta Sport', 'Mica', 3);
INSERT INTO jucarie VALUES (2, 2, 'Casuta Papusi', 'Mare', 5);
INSERT INTO jucarie VALUES (3, 4, 'Robotel Inteligent', 'Medie', 7);
INSERT INTO jucarie VALUES (4, 1, 'Set Cuburi Constructie', 'Medie', 4);
INSERT INTO jucarie VALUES (5, 3, 'Ursulet de Plus', 'Mare', 0);

INSERT INTO comanda VALUES (1, 1, 5, 1, 150.00, 'Card');
INSERT INTO comanda VALUES (2, 2, 1, 3, 2400.00, 'Transfer');
INSERT INTO comanda VALUES (3, 3, 5, 2, 85.50, 'Cash');
INSERT INTO comanda VALUES (4, 4, 2, 3, 5000.00, 'Transfer');
INSERT INTO comanda VALUES (5, 5, 5, 5, 320.00, 'Card');

INSERT INTO detaliu VALUES (1, 1, 1, 2, TO_DATE('2025-12-20', 'YYYY-MM-DD'), '10:00');
INSERT INTO detaliu VALUES (2, 1, 4, 1, TO_DATE('2025-12-20', 'YYYY-MM-DD'), '10:05');
INSERT INTO detaliu VALUES (3, 2, 1, 50, TO_DATE('2025-12-21', 'YYYY-MM-DD'), '11:20');
INSERT INTO detaliu VALUES (4, 2, 2, 10, TO_DATE('2025-12-21', 'YYYY-MM-DD'), '11:25');
INSERT INTO detaliu VALUES (5, 3, 3, 1, TO_DATE('2025-12-22', 'YYYY-MM-DD'), '09:40');
INSERT INTO detaliu VALUES (6, 4, 4, 100, TO_DATE('2025-12-23', 'YYYY-MM-DD'), '15:10');
INSERT INTO detaliu VALUES (7, 4, 5, 50, TO_DATE('2025-12-23', 'YYYY-MM-DD'), '15:15');
INSERT INTO detaliu VALUES (8, 5, 1, 3, TO_DATE('2025-12-24', 'YYYY-MM-DD'), '13:00');
INSERT INTO detaliu VALUES (9, 5, 2, 1, TO_DATE('2025-12-24', 'YYYY-MM-DD'), '13:05');
INSERT INTO detaliu VALUES (10, 2, 3, 5, TO_DATE('2025-12-21', 'YYYY-MM-DD'), '11:30');
INSERT INTO mijloc_de_transport VALUES (6, 1, 'IVECO Daily', 5.0, 'B-102-FST');
INSERT INTO mijloc_de_transport VALUES (7, 1, 'MAN TGL', 7.5, 'B-103-FST');
COMMIT;
UPDATE transportator t
SET t.numar_mijloace = (
    SELECT COUNT(*) 
    FROM mijloc_de_transport m 
    WHERE m.id_transportator = t.id_transportator
);

COMMIT;
--denumirile jucăriilor produse , cantitățile vândute pentru acele jucării și o mapare între ID-ul jucăriei și prețul total generat. 
--6
create or replace procedure analiza_linie_productie (p_id_linie  number) is
    type t_vector_nume is varray(100) of varchar2(100);
    v_nume_jucarii t_vector_nume := t_vector_nume();
    
    type t_tab_cantitate is table of number;
    v_cantitati t_tab_cantitate :=t_tab_cantitate();
    
    type t_tab_preturi is table of number  index by binary_integer;
    v_preturi_totale t_tab_preturi;
    v_idx_pret binary_integer;
    
    begin
    for r in(
    SELECT j.id_jucarie, j.denumire, SUM(d.cantitate) as total_bucati, SUM(d.cantitate * c.pret_total / 10) as valoare_estimata
        from jucarie j
        join detaliu d on j.id_jucarie = d.id_jucarie
        JOIN comanda c on d.id_comanda = c.id_comanda
        WHERE j.id_linie = p_id_linie
        GROUP BY j.id_jucarie, j.denumire
    )loop
    
    v_nume_jucarii.extend;
    v_nume_jucarii(v_nume_jucarii.last) :=r.denumire;
    
    v_cantitati.extend;
    v_cantitati(v_cantitati.last):=r.total_bucati;
    
    v_preturi_totale(r.id_jucarie) := r.valoare_estimata;
    END loop;
    
    dbms_output.put_line('Raport linie de productie ' || p_id_linie);
    for i in 1..v_nume_jucarii.count loop
        dbms_output.put_line('Jucarie: ' || v_nume_jucarii(i) || ' Cantitatea vanduta: ' || v_cantitati(i));
    end loop;
    
    dbms_output.put_line('Sumar venituri per ID jucarie');
    v_idx_pret:=v_preturi_totale.first;
    while v_idx_pret is not null loop
        dbms_output.put_line('Id jucarie: '|| v_idx_pret || ' Venit: '||v_preturi_totale(v_idx_pret) || ' RON');
        v_idx_pret := v_preturi_totale.next(v_idx_pret);
    end loop;
end;
/
SET SERVEROUTPUT ON;

BEGIN
    -- Apelam procedura pentru linia de productie cu ID 1
    analiza_linie_productie(1);
END;
/
--7
create or replace procedure afisare_detalii_transportatori is
    cursor c_firme is
    select id_transportator, nume_firma, email, telefon FROM transportator;
    cursor c_mijloace(p_id NUMBER) IS 
        select marca, numar_immatriculare, tonaj_maxim 
        from mijloc_de_transport 
        where id_transportator = p_id;
    v_firma_rec c_firme%ROWTYPE;
    v_mijloc_rec c_mijloace%ROWTYPE;
    begin
    open c_firme;
    loop
        fetch c_firme into v_firma_rec;
        exit when c_firme%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(' ');
        DBMS_OUTPUT.PUT_LINE('FIRMA: ' || UPPER(v_firma_rec.nume_firma));
        DBMS_OUTPUT.PUT_LINE('CONTACT: ' || v_firma_rec.email || ' | Tel: ' || v_firma_rec.telefon);
        DBMS_OUTPUT.PUT_LINE('LISTA MIJLOACE DE TRANSPORT:');
    open c_mijloace(v_firma_rec.id_transportator);
    loop
        fetch c_mijloace into v_mijloc_rec;
        exit when c_mijloace %notfound;
        DBMS_OUTPUT.PUT_LINE('   -> [' || v_mijloc_rec.numar_immatriculare || '] Marca: ' || 
                               v_mijloc_rec.marca || ' (Tonaj: ' || v_mijloc_rec.tonaj_maxim || 't)');
    end loop;
    if c_mijloace%ROWCOUNT = 0 then
            DBMS_OUTPUT.PUT_LINE('   (Aceasta firma nu are mijloace de transport inregistrate)');
        end if;
    close c_mijloace;
    end loop;
    close c_firme;
    end;
    /
set serveroutput on;
begin
    afisare_detalii_transportatori;
end;
/
--nr de jucarii cumparate de client de-alungul timpului
--8
CREATE OR REPLACE FUNCTION f_total_obiecte_client(p_nume_client VARCHAR2)
RETURN NUMBER IS
    v_total NUMBER;
    v_count_clienti NUMBER;
BEGIN
    SELECT 
        COUNT(DISTINCT c.id_client), 
        NVL(SUM(d.cantitate), 0)      
    INTO 
        v_count_clienti,
        v_total
    FROM 
        client c
        LEFT JOIN comanda co ON c.id_client = co.id_client
        LEFT JOIN detaliu d ON co.id_comanda = d.id_comanda
    WHERE 
        c.nume = p_nume_client;
    
   
    IF v_count_clienti = 0 THEN
        RAISE NO_DATA_FOUND;
    ELSIF v_count_clienti > 1 THEN
        RAISE TOO_MANY_ROWS;
    END IF;
    RETURN v_total;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 
            'Eroare: Clientul cu numele "' || p_nume_client || '" nu a fost gasit in baza de date.');
    
    WHEN TOO_MANY_ROWS THEN
        RAISE_APPLICATION_ERROR(-20002, 
            'Eroare: Exista mai multi clienti cu numele "' || p_nume_client || 
            '". Va rugam folositi un identifiator unic .');
    
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20999, 
            'Eroare neasteptata: ' || SQLERRM);
END f_total_obiecte_client;
/
SET SERVEROUTPUT ON;


DECLARE
    v_rezultat NUMBER;
BEGIN
    v_rezultat := f_total_obiecte_client('Georgescu');
    DBMS_OUTPUT.PUT_LINE('Clientul Georgescu a comandat ' || v_rezultat || ' jucarii.');
END;
/
INSERT INTO client VALUES (200, 'Popescu', 'Mircea', 'PF', 'mircea.p@test.ro');
COMMIT;

DECLARE
    v_rezultat NUMBER;
BEGIN
    v_rezultat := f_total_obiecte_client('Popescu');
    DBMS_OUTPUT.PUT_LINE('Rezultat: ' || v_rezultat);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Eroare: ' || SQLERRM);
END;
/

DECLARE
    v_rezultat NUMBER;
BEGIN
    v_rezultat := f_total_obiecte_client('NumeInexistent');
    DBMS_OUTPUT.PUT_LINE('Rezultat: ' || v_rezultat);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Eroare: ' || SQLERRM);
END;
/
INSERT INTO client VALUES (201, 'ClientFaraComenzi', 'Test', 'PF', 'test@none.ro');
COMMIT;

DECLARE
    v_rezultat NUMBER;
BEGIN
    v_rezultat := f_total_obiecte_client('ClientFaraComenzi');
    DBMS_OUTPUT.PUT_LINE('Clientul ClientFaraComenzi a comandat ' || v_rezultat || ' jucarii.');
END;
/
--procedura pentru performanta unui angajat
--9
create or replace procedure raport_performanta_comenzi(p_nume_angajat varchar2, p_prag_cantitate number) is
    e_senioritate_mica exception;
    e_fara_comenzi_mari exception;
    v_vechime number;
    v_numar_linii_gasite number :=0;
    begin
    select vechime into v_vechime
    from angajat
    where nume =p_nume_angajat;
    
    if v_vechime < 2 then
    raise e_senioritate_mica;
    end if;
     dbms_output.put_line('raport pentru angajatul '||p_nume_angajat);
     for r in 
     (
     select a.nume as nume_ang, j.denumire as nume_jucarie, d.cantitate, c.pret_total, c.id_comanda
        from angajat a
        join linie_productie lp on a.id_linie = lp.id_linie
        join jucarie j on lp.id_linie = j.id_linie
        join detaliu d on j.id_jucarie = d.id_jucarie
        join comanda c on d.id_comanda = c.id_comanda
        where a.nume = p_nume_angajat and d.cantitate >= p_prag_cantitate
     )loop
     v_numar_linii_gasite:= v_numar_linii_gasite + 1;
        dbms_output.put_line('comanda nr: ' || r.id_comanda ||' jucarie: ' || r.nume_jucarie || ' | cantitate: ' || r.cantitate || ' | valoare comanda: ' || r.pret_total);
    end loop;
    if v_numar_linii_gasite <=0 then
    raise e_fara_comenzi_mari;
    end if;
    exception
    when too_many_rows then
        dbms_output.put_line('eroare: exista mai multi angajati cu numele ' || p_nume_angajat || '. cautarea nu este precisa.');
    when e_senioritate_mica then
        dbms_output.put_line('exceptie proprie: angajatul ' || p_nume_angajat || ' are vechime prea mica pentru raport.');
    when e_fara_comenzi_mari then
        dbms_output.put_line('exceptie proprie: nu exista vanzari peste pragul de ' || p_prag_cantitate || ' bucati pentru linia acestui angajat.');
    when no_data_found then
        dbms_output.put_line('eroare sistem: angajatul cu numele ' || p_nume_angajat || ' nu a fost gasit.');
    when others then
        dbms_output.put_line('eroare neasteptata: ' || sqlerrm);
end;
/
set serveroutput on;
begin
  raport_performanta_comenzi('Popescu', 2);
end;
/    
set serveroutput on;
begin
  raport_performanta_comenzi('Danescu', 1000000);
end;
/    
set serveroutput on;
begin
  raport_performanta_comenzi('Tanasoiu', 10);
end;
/ 
set serveroutput on;
begin
  raport_performanta_comenzi('Andrei',1);
end;
/
--trigger lmd la nivel de comanda
--10
create or replace trigger trg_securitate_comenzi
before insert or update or delete on comanda
begin
    if (to_char(sysdate, 'dy', 'nls_date_language = american') in ('sat', 'sun')) or
       (to_number(to_char(sysdate, 'hh24')) not between 8 and 17) then
        raise_application_error(-20500, 'stop! tabelul comanda poate fi modificat doar de luni pana vineri, intre orele 08:00 si 18:00.');
    end if;
end;
/
update comanda set metoda_plata = 'Cash' where id_comanda = 1;
--trigger lmd la nivel de linie
--11
create or replace trigger trg_update_mijloace_transport
after insert or delete on mijloc_de_transport
for each row
begin
    if inserting then
        update transportator
        set numar_mijloace = nvl(numar_mijloace, 0) + 1
        where id_transportator = :new.id_transportator;
    elsif deleting then
        update transportator
        set numar_mijloace = numar_mijloace - 1
        where id_transportator = :old.id_transportator;
    end if;
end;
/
select numar_mijloace from transportator where id_transportator = 1;
insert into mijloc_de_transport values (50, 1, 'dacia logan', 1, 'b-01-toy');
select numar_mijloace from transportator where id_transportator = 1;
delete from mijloc_de_transport where id_mijloc = 50;
select numar_mijloace from transportator where id_transportator = 1;
--trigger ldd
--12
create table log_structura_fabrica(
 utilizator varchar2(50),
 eveniment varchar2(50),
 tip_obiect varchar2(50),
 nume_obiect varchar2(50),
 data_eveniment date
);
create or replace trigger trg_audit_structura
after create or alter or drop on schema
begin 
    insert into log_structura_fabrica(
    utilizator, 
        eveniment, 
        tip_obiect, 
        nume_obiect, 
        data_eveniment
    )
    values 
    (
    sys_context('userenv', 'session_user'),
    ora_sysevent,                           
    ora_dict_obj_type,                      
    ora_dict_obj_name,                     
    sysdate
    );
  end;
  /
create table test_proiect (id number);
alter table test_proiect add descriere varchar2(100);
drop table test_proiect;

select * from log_structura_fabrica order by data_eveniment desc;
--13

create or replace package  pachet_management as
type t_audit_rec is record(
 nume_jucarie varchar2(100),
 material varchar2(100),
 densitate number
);
type t_lista_audit is table of t_audit_rec index by pls_integer;
function procent_ong_mediu(p_an number) return number;
function client_top return varchar2;
procedure echilibrare_linii;
procedure audit_materiale_linie(p_id_linie number);
PROCEDURE rulare_procesare_lunara(p_an_raportare number, p_linie_audit number);
end pachet_management;
/
create or replace package body pachet_management as
function procent_ong_mediu(p_an number) return number is
 v_medie number;
begin
    select avg(d.procent) into v_medie
    from discount d
    join comanda c on d.id_discount = c.id_discount
        join client cl on c.id_client = cl.id_client
        join detaliu det on c.id_comanda = det.id_comanda
        where cl.tip = 'ONG' and to_char(det.data_detaliu, 'YYYY') = to_char(p_an);
        return nvl(v_medie, 0);
        end procent_ong_mediu;
function client_top return varchar2 is v_nume varchar2(100);
begin
        select prenume || ' ' || nume into v_nume
        from (
            select cl.nume, cl.prenume, sum(c.pret_total)
            from client cl
            join comanda c on cl.id_client = c.id_client
            group by cl.id_client, cl.nume, cl.prenume
            order by 3 desc
        ) where rownum = 1;
        return v_nume;
end client_top;
procedure echilibrare_linii is
        v_medie_fabrica number;
    begin
        select avg(capacitate_maxima) into v_medie_fabrica from linie_productie;
        
        update linie_productie
        set capacitate_maxima = v_medie_fabrica
        where capacitate_maxima < v_medie_fabrica;
        
        dbms_output.put_line('Capacitatile au fost echilibrate la media de: ' || round(v_medie_fabrica, 2));
    end echilibrare_linii;
procedure audit_materiale_linie(p_id_linie number) is
        v_colectie t_lista_audit;
        v_idx number := 0;
    begin
        for r in (
            select j.denumire, mp.tip_material, mp.densitate
            from jucarie j
            join linie_productie lp on j.id_linie = lp.id_linie
            join materie_prima mp on lp.id_materie = mp.id_materie
            where lp.id_linie = p_id_linie
        ) loop
            v_idx := v_idx + 1;
            v_colectie(v_idx).nume_jucarie := r.denumire;
            v_colectie(v_idx).material := r.tip_material;
            v_colectie(v_idx).densitate := r.densitate;
        end loop;

        dbms_output.put_line('--- RAPORT AUDIT LINIE ' || p_id_linie || ' ---');
        for i in 1..v_colectie.count loop
            dbms_output.put_line('Jucarie: ' || v_colectie(i).nume_jucarie || 
                                 ' | Material: ' || v_colectie(i).material || 
                                 ' | Densitate: ' || v_colectie(i).densitate);
        end loop;
    end audit_materiale_linie;
PROCEDURE rulare_procesare_lunara(p_an_raportare NUMBER, p_linie_audit NUMBER) IS
        v_nume_top VARCHAR2(100);
        v_medie_ong NUMBER;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('   RAPORT INTEGRAT DE INCHIDERE LUNARA - FABRICA');
        DBMS_OUTPUT.PUT_LINE('1. ACTIUNE: Optimizare capacitati productie...');
        echilibrare_linii;
        DBMS_OUTPUT.PUT_LINE('2. ACTIUNE: Auditare materiale pentru Linia ' || p_linie_audit || '...');
        audit_materiale_linie(p_linie_audit); 
        v_nume_top := client_top; 
        v_medie_ong := procent_ong_mediu(p_an_raportare); 
        DBMS_OUTPUT.PUT_LINE('3. DASHBOARD FINANCIAR  SOCIAL (' || p_an_raportare || ')');
        DBMS_OUTPUT.PUT_LINE('   > Clientul Anului (MVP): ' || v_nume_top);
        DBMS_OUTPUT.PUT_LINE('   > Media Discount ONG:    ' || ROUND(v_medie_ong, 2) || '%');
        DBMS_OUTPUT.PUT_LINE('   PROCES FINALIZAT CU SUCCES.');
    END rulare_procesare_lunara;
end pachet_management;
/
SET SERVEROUTPUT ON;

BEGIN
    pachet_management.rulare_procesare_lunara(2025, 1);
END;
/
    