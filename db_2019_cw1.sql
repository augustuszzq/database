#Q1
SELECT personb.name,persona.dod
FROM   person AS personb JOIN person AS persona ON persona.name=personb.mother
WHERE  (persona.dod) IS NOT NULL
;
name            |    dod
---------------------------+------------
Charles II                | 1669-09-10
James II                  | 1669-09-10
Mary (Princess Royal)     | 1669-09-10
Mary II                   | 1671-04-10
William III               | 1660-12-24
Anne                      | 1671-04-10
Palatine Sophia           | 1662-02-13
George I                  | 1714-06-08
George III                | 1772-02-08
George IV                 | 1818-11-17
Frederick (Prince)        | 1818-11-17
William IV                | 1818-11-17
Edward (Prince)           | 1818-11-17
Victoria (Princess Royal) | 1901-01-22
Edward VII                | 1901-01-22
Alice (Princess)          | 1901-01-22
Alfred                    | 1901-01-22
Albert Victor             | 1925-11-20
George V                  | 1925-11-20
Alice (Princess Royal)    | 1925-11-20
George VI                 | 1953-03-24
Edward VIII               | 1953-03-24
Elizabeth II              | 2002-03-30
Margaret                  | 2002-03-30
Philip                    | 1969-12-05
Diana                     | 2004-06-03
Henry                     | 1997-08-31
William                   | 1997-08-31
(28 rows)


#Q2
SELECT name
FROM   person
WHERE  gender = 'M'
EXCEPT
SELECT name
FROM   person
WHERE name IN (SELECT person.name
              FROM person JOIN person AS son ON person.name = son.father)
ORDER BY name
;
name
--------------------------
Albert Victor
Alec Douglas-Home
Alfred
Andrew
Andrew Bonar Law
Anthony Eden
Arthur Balfour
Benjamin Disraeli
Charles II
Clement Attlee
Constantine I of Greece
David Cameron
David Lloyd George
Earl of Rosebery
Edward
Edward Heath
Edward VIII
Frederick (Prince)
George IV
Gordon Brown
Harold Macmillan
Harold Wilson
Henry
Henry Campbell-Bannerman
Herbert Henry Asquith
James Callaghan
John Major
Lord Salisbury
Neville Chamberlain
Ramsay MacDonald
Richard Cromwell
Stanley Baldwin
Tony Blair
William
William Ewart Gladstone
William III
William IV
Winston Churchill
(38 rows)

#Q3

SELECT mother.name
FROM person AS mother
WHERE not exists (
                  SELECT  gender
                  FROM    person
                  EXCEPT
                  SELECT  gender
                  FROM    person
                  WHERE   person.mother = mother.name)
ORDER BY name
;
name
-------------------
Alexandra (Queen)
Elizabeth II
Henrietta Maria
Victoria
(4 rows)


#Q4
SELECT name,father,mother
FROM   person
WHERE dob<= ALL(SELECT dob
                FROM person AS t
                WHERE t.mother = mother AND t.father=father)
;


#Q5
SELECT CASE WHEN POSITION(' ' IN person.name)<>0
THEN SUBSTRING(person.name,1,POSITION(' ' IN person.name)-1)
ELSE person.name
END AS Firstname,
COUNT(name) AS popularity
FROM person
GROUP BY Firstname
Having COUNT(name)>1
ORDER BY popularity DESC , Firstname
;
firstname | popularity
-----------+------------
George    |          7
Edward    |          5
William   |          5
Alice     |          3
Andrew    |          3
Anne      |          3
Charles   |          3
Elizabeth |          3
James     |          3
Mary      |          3
Albert    |          2
David     |          2
Frederick |          2
Harold    |          2
Henry     |          2
Margaret  |          2
Victoria  |          2
(17 rows)
#Q6

SELECT person.name ,SUM(CASE WHEN child.dob>='1940-1-1' AND child.dob<'1950-1-1' THEN 1 ELSE 0 END),
                    SUM(CASE WHEN child.dob>='1950-1-1' AND child.dob<'1960-1-1' THEN 1 ELSE 0 END),
                    SUM(CASE WHEN child.dob>='1960-1-1' AND child.dob<'1970-1-1' THEN 1 ELSE 0 END)
FROM person JOIN person AS child ON person.name = child.mother
                                  OR person.name = child.father
GROUP BY person.name
HAVING COUNT(child.mother)>1 OR COUNT(child.father)>1
ORDER BY person.name
;
name        | sum | sum | sum
--------------------+-----+-----+-----
Albert             |   0 |   0 |   0
Alexandra (Queen)  |   0 |   0 |   0
Anne Hyde          |   0 |   0 |   0
Charles            |   0 |   0 |   0
Charles I          |   0 |   0 |   0
Charlotte          |   0 |   0 |   0
Diana              |   0 |   0 |   0
Edward VII         |   0 |   0 |   0
Elizabeth          |   0 |   0 |   0
Elizabeth II       |   1 |   1 |   2
George III         |   0 |   0 |   0
George I of Greece |   0 |   0 |   0
George V           |   0 |   0 |   0
George VI          |   0 |   0 |   0
Henrietta Maria    |   0 |   0 |   0
James I            |   0 |   0 |   0
James II           |   0 |   0 |   0
Mary of Teck       |   0 |   0 |   0
Philip             |   1 |   1 |   2
Victoria           |   0 |   0 |   0
(20 rows)

#Q7
SELECT mother,father,name as name,
RANK() OVER(PARTITION BY father,mother ORDER BY dob) AS bron
FROM person
WHERE father IS NOT NULL AND mother IS NOT NULL
GROUP BY father,mother,name
ORDER BY father,mother,bron
;
mother         |        father        |        child_name         | bron
-----------------------+----------------------+---------------------------+------
Victoria              | Albert               | Victoria (Princess Royal) |    1
Victoria              | Albert               | Edward VII                |    2
Victoria              | Albert               | Alice (Princess)          |    3
Victoria              | Albert               | Alfred                    |    4
Alice                 | Andrew of Greece     | Philip                    |    1
Diana                 | Charles              | William                   |    1
Diana                 | Charles              | Henry                     |    2
Henrietta Maria       | Charles I            | Charles II                |    1
Henrietta Maria       | Charles I            | Mary (Princess Royal)     |    2
Henrietta Maria       | Charles I            | James II                  |    3
Alexandra (Queen)     | Edward VII           | Albert Victor             |    1
Alexandra (Queen)     | Edward VII           | George V                  |    2
Alexandra (Queen)     | Edward VII           | Alice (Princess Royal)    |    3
Palatine Sophia       | Ernest Augustus      | George I                  |    1
Augusta of Saxe-Gotha | Frederick            | George III                |    1
Charlotte             | George III           | Frederick (Prince)        |    1
Charlotte             | George III           | George IV                 |    2
Charlotte             | George III           | William IV                |    2
Charlotte             | George III           | Edward (Prince)           |    4
Mary of Teck          | George V             | Edward VIII               |    1
Mary of Teck          | George V             | George VI                 |    2
Elizabeth             | George VI            | Elizabeth II              |    1
Elizabeth             | George VI            | Margaret                  |    2
Anne Hyde             | James II             | Mary II                   |    1
Anne Hyde             | James II             | Anne                      |    2
Elizabeth II          | Philip               | Charles                   |    1
Elizabeth II          | Philip               | Anne (Princess)           |    2
Elizabeth II          | Philip               | Andrew                    |    3
Elizabeth II          | Philip               | Edward                    |    4
Mary (Princess Royal) | William II of Orange | William III               |    1
(30 rows)

#Q8
SELECT father,mother,ROUND(100*COUNT(CASE WHEN gender ='M' THEN 1 ELSE 0 END)/COUNT(father))
FROM person
WHERE father IS NOT NULL AND mother IS NOT NULL
GROUP BY father,mother
ORDER BY father,mother
;

// all data
SELECT *
FROM person
;
name            | gender |    dob     |    dod     |        father        |        mother         |       born_in
---------------------------+--------+------------+------------+----------------------+-----------------------+---------------------
Charles I                 | M      | 1600-11-19 | 1649-01-30 | James I              |                       | Dumfermline
Charles II                | M      | 1630-06-08 | 1685-02-06 | Charles I            | Henrietta Maria       | London
James II                  | M      | 1633-10-24 | 1701-09-16 | Charles I            | Henrietta Maria       | London
Henrietta Maria           | F      | 1609-11-25 | 1669-09-10 |                      |                       | Paris
Mary (Princess Royal)     | F      | 1631-11-04 | 1660-12-24 | Charles I            | Henrietta Maria       | London
Anne Hyde                 | F      | 1638-03-22 | 1671-04-10 |                      |                       | Windsor
Mary II                   | F      | 1662-05-10 | 1695-01-07 | James II             | Anne Hyde             | London
William II of Orange      | M      | 1626-05-27 | 1650-11-06 |                      |                       | The Hague
William III               | M      | 1650-11-14 | 1702-03-08 | William II of Orange | Mary (Princess Royal) | London
Anne                      | F      | 1665-02-06 | 1714-08-01 | James II             | Anne Hyde             | London
Ernest Augustus           | M      | 1629-11-20 | 1698-01-23 |                      |                       | Herzberg am Harz
Palatine Sophia           | F      | 1630-10-14 | 1714-06-08 |                      | Elizabeth of Bohemia  | The Hague
Elizabeth of Bohemia      | F      | 1596-08-19 | 1662-02-13 | James I              |                       | Fife
James I                   | M      | 1566-06-19 | 1625-03-27 |                      |                       | Fife
George I                  | M      | 1660-06-07 | 1727-06-22 | Ernest Augustus      | Palatine Sophia       | Hanover
George II                 | M      | 1683-11-09 | 1760-10-25 | George I             |                       | Hanover
Frederick                 | M      | 1707-02-01 | 1751-03-20 | George II            |                       | Hanover
George III                | M      | 1738-08-21 | 1820-01-29 | Frederick            | Augusta of Saxe-Gotha | London
Augusta of Saxe-Gotha     | F      | 1719-11-30 | 1772-02-08 |                      |                       | Gotha
Charlotte                 | F      | 1744-05-19 | 1818-11-17 |                      |                       | Mecklenburg-Streliz
George IV                 | M      | 1765-08-21 | 1830-06-26 | George III           | Charlotte             | London
Frederick (Prince)        | M      | 1763-08-16 | 1827-01-05 | George III           | Charlotte             | London
William IV                | M      | 1765-08-21 | 1837-06-20 | George III           | Charlotte             | London
Victoria                  | F      | 1819-05-24 | 1901-01-22 | Edward (Prince)      |                       | London
Edward (Prince)           | M      | 1767-11-02 | 1820-01-23 | George III           | Charlotte             | London
Albert                    | M      | 1819-08-26 | 1861-12-14 |                      |                       | Coburg
Victoria (Princess Royal) | F      | 1840-11-21 | 1901-08-05 | Albert               | Victoria              | London
Edward VII                | M      | 1841-11-09 | 1910-05-06 | Albert               | Victoria              | London
Alexandra (Queen)         | F      | 1844-12-01 | 1925-11-20 |                      |                       | Copenhagen
Alice (Princess)          | F      | 1843-04-25 | 1878-12-14 | Albert               | Victoria              | London
Alfred                    | M      | 1844-08-06 | 1900-07-30 | Albert               | Victoria              | Windsor Castle
Albert Victor             | M      | 1864-01-08 | 1892-01-14 | Edward VII           | Alexandra (Queen)     | Frogmore
George V                  | M      | 1865-06-03 | 1936-01-20 | Edward VII           | Alexandra (Queen)     | London
Alice (Princess Royal)    | F      | 1867-02-20 | 1931-01-04 | Edward VII           | Alexandra (Queen)     | London
Mary of Teck              | F      | 1867-05-26 | 1953-03-24 |                      |                       | London
George VI                 | M      | 1895-12-14 | 1952-02-06 | George V             | Mary of Teck          | Sandringham
Edward VIII               | M      | 1894-06-23 | 1972-05-28 | George V             | Mary of Teck          | Sandringham
Elizabeth                 | F      | 1900-08-04 | 2002-03-30 |                      |                       | London
Elizabeth II              | F      | 1926-04-21 |            | George VI            | Elizabeth             | London
Margaret                  | F      | 1930-08-21 | 2002-02-09 | George VI            | Elizabeth             | Glamis Castle
George I of Greece        | M      | 1845-12-24 | 1913-03-18 |                      |                       | Copenhagen
Andrew of Greece          | M      | 1882-02-02 | 1944-12-03 | George I of Greece   |                       | Athens
Constantine I of Greece   | M      | 1868-08-02 | 1923-01-11 | George I of Greece   |                       | Athens
Alice                     | F      | 1885-02-25 | 1969-12-05 |                      |                       | Windsor
Philip                    | M      | 1921-06-10 |            | Andrew of Greece     | Alice                 | Corfu
Charles                   | M      | 1948-11-14 |            | Philip               | Elizabeth II          | London
Anne (Princess)           | F      | 1950-08-15 |            | Philip               | Elizabeth II          | London
Andrew                    | M      | 1960-02-19 |            | Philip               | Elizabeth II          | London
Edward                    | M      | 1964-03-10 |            | Philip               | Elizabeth II          | London
Frances                   | F      | 1936-01-20 | 2004-06-03 |                      |                       | Sandringham
Diana                     | F      | 1961-07-01 | 1997-08-31 |                      | Frances               | Sandringham
Henry                     | M      | 1984-09-15 |            | Charles              | Diana                 | London
William                   | M      | 1982-06-21 |            | Charles              | Diana                 | London
Oliver Cromwell           | M      | 1599-04-25 | 1658-09-03 |                      |                       | Huntingdon
Richard Cromwell          | M      | 1626-10-04 | 1659-05-25 | Oliver Cromwell      |                       | Huntingdon
David Cameron             | M      | 1966-10-09 |            |                      |                       | London
Gordon Brown              | M      | 1951-02-20 |            |                      |                       | Giffnock
Tony Blair                | M      | 1953-05-06 |            |                      |                       | Edinburgh
John Major                | M      | 1943-03-29 |            |                      |                       | Carshalton
Margaret Thatcher         | F      | 1925-10-13 |            |                      |                       | Grantham
