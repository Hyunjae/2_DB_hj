-- BASIC SELECT

--1 학과명, 계
SELECT DEPARTMENT_NAME 학과명, CATEGORY 계열
FROM TB_DEPARTMENT;

--2 학과 정원 O
SELECT DEPARTMENT_NAME || '의 정원은' || CAPACITY || ' 명 입니다.' " 학과별 정원"
FROM TB_DEPARTMENT;

--3 국문학과 휴학생 여학생
SELECT STUDENT_NAME
FROM TB_STUDENT
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
WHERE DEPARTMENT_NAME ='국어국문학과'
AND ABSENCE_YN = 'Y'
AND SUBSTR(STUDENT_SSN, 8, 1) = '2';

-- 4. 학번으로 이름 조회
SELECT STUDENT_NAME
FROM TB_STUDENT
WHERE STUDENT_NO IN('A513079', 'A513090', 'A513091', 'A513110', 'A513119');

-- 5. 입학 정원이 20명 이상 30명 이하인 학과 이름과 계열
SELECT DEPARTMENT_NAME, CATEGORY
FROM TB_DEPARTMENT
WHERE CAPACITY BETWEEN 20 AND 30;

-- 6. 
SELECT PROFESSOR_NAME
FROM TB_PROFESSOR
WHERE DEPARTMENT_NO IS NULL;

-- 7.
SELECT STUDENT_NAME
FROM TB_STUDENT
WHERE DEPARTMENT_NO IS NULL;

-- 8. 
SELECT PREATTENDING_CLASS_NO CLASS_NO
FROM TB_CLASS
WHERE PREATTENDING_CLASS_NO IS NOT NULL;

-- 9.
SELECT DISTINCT(CATEGORY)
FROM TB_DEPARTMENT;

-- 10.
SELECT STUDENT_NO, STUDENT_NAME, STUDENT_SSN
FROM TB_STUDENT
WHERE EXTRACT(YEAR FROM ENTRANCE_DATE) = 2002
AND SUBSTR(STUDENT_ADDRESS, 1, 2) = '전주'
AND ABSENCE_YN = 'N';


-- ADDITIONAL SELECT 
--1.
SELECT STUDENT_NO 학과, STUDENT_NAME 이름, ENTRANCE_DATE 입학년도
FROM TB_STUDENT
WHERE DEPARTMENT_NO = '002';

--2.
SELECT PROFESSOR_NAME, PROFESSOR_SSN
FROM TB_PROFESSOR
WHERE LENGTH(PROFESSOR_NAME)!=3;

--3.
SELECT PROFESSOR_NAME 교수이름, 
	FLOOR(MONTHS_BETWEEN(SYSDATE, TO_DATE(19 || SUBSTR(PROFESSOR_SSN, 1, 6))) / 12) 나이
FROM TB_PROFESSOR
WHERE SUBSTR(PROFESSOR_SSN, 8, 1) ='1'
ORDER BY 나이;

--4.
SELECT SUBSTR(PROFESSOR_NAME, 2,4)
FROM TB_PROFESSOR;

--5.
SELECT STUDENT_NO, STUDENT_NAME
FROM TB_STUDENT
WHERE EXTRACT(YEAR FROM ENTRANCE_DATE)
	- EXTRACT(YEAR FROM TO_DATE(SUBSTR(STUDENT_SSN,1,6))) > 19;

--6.
SELECT TO_CHAR(TO_DATE('2020-12-25'), 'DAY') FROM DUAL; 

--7. 
SELECT TO_DATE('99-10-11', 'YY/MM/DD') FROM DUAL;
SELECT TO_DATE('49-10-11', 'YY/MM/DD') FROM DUAL;
SELECT TO_DATE('99-10-11', 'RR/MM/DD') FROM DUAL;
SELECT TO_DATE('49-10-11', 'RR/MM/DD') FROM DUAL;

--8.
SELECT STUDENT_NO, STUDENT_NAME
FROM TB_STUDENT
WHERE SUBSTR(STUDENT_NO, 1, 1) != 'A';

--9.
SELECT ROUND(AVG(POINT), 1) 평점
FROM TB_GRADE
WHERE STUDENT_NO = 'A517178';

--10.
SELECT DEPARTMENT_NO 학과번호, COUNT(*) "학생수(명)"
FROM TB_STUDENT
GROUP BY DEPARTMENT_NO
ORDER BY 1;

--11.
SELECT COUNT(*)
FROM TB_STUDENT
WHERE COACH_PROFESSOR_NO IS NULL;

--12.
SELECT SUBSTR(TERM_NO, 1, 4) 년도, ROUND(AVG(POINT),1) "년도 별 평점"
FROM TB_GRADE
WHERE STUDENT_NO = 'A112113'
GROUP BY SUBSTR(TERM_NO, 1, 4)
ORDER BY 1;

--13.
SELECT DEPARTMENT_NO "학과 코드명", COUNT(DECODE(ABSENCE_YN, 'Y', 1))
--COUNT는 NULL을 제외하고 세기 때문에 
--SUM(DECODE(ABSENCE_YN, 'Y', 1, 0)) "휴학생 수"
FROM TB_STUDENT
GROUP BY DEPARTMENT_NO
ORDER BY 1;

--14.
SELECT STUDENT_NAME 동일이름, COUNT(*) "동명인 수"
FROM TB_STUDENT
GROUP BY STUDENT_NAME
HAVING COUNT(*)>1
ORDER BY 1;

--15.
SELECT NVL(SUBSTR(TERM_NO, 1, 4), ' ')년도, NVL(SUBSTR(TERM_NO, 5, 2), ' ') 학기, ROUND(AVG(POINT), 1) 평점
FROM TB_GRADE
WHERE STUDENT_NO = 'A112113'
GROUP BY ROLLUP(SUBSTR(TERM_NO, 1, 4), SUBSTR(TERM_NO, 5, 2))
ORDER BY SUBSTR(TERM_NO, 1, 4), SUBSTR(TERM_NO, 5, 2);


--Additional SELECT - Option

-- 1.
SELECT STUDENT_NAME "학생 이름", STUDENT_ADDRESS 주소지
FROM TB_STUDENT
ORDER BY "학생 이름";

-- 2.
SELECT STUDENT_NAME, STUDENT_SSN
FROM TB_STUDENT
WHERE ABSENCE_YN = 'Y'
ORDER BY STUDENT_SSN DESC;

-- 3.
SELECT STUDENT_NAME 학생이름, STUDENT_NO 학번, STUDENT_ADDRESS "거주지 주소"
FROM TB_STUDENT
WHERE SUBSTR(STUDENT_ADDRESS,1,2) IN ('강원', '경기')
AND SUBSTR(STUDENT_NO,1,1) = '9'
ORDER BY 학생이름;

--4.
SELECT PROFESSOR_NAME, PROFESSOR_SSN
FROM TB_PROFESSOR
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
WHERE DEPARTMENT_NAME = '법학과'
ORDER BY PROFESSOR_SSN;

--5. 
SELECT STUDENT_NO, TO_CHAR(POINT, 'FM9.00') 학점
FROM TB_GRADE
WHERE TERM_NO = '200402'
AND CLASS_NO = 'C3118100'
ORDER BY 학점 DESC, STUDENT_NO ASC;

--6. 
SELECT STUDENT_NO, STUDENT_NAME, DEPARTMENT_NAME
FROM TB_STUDENT
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
ORDER BY STUDENT_NAME ASC;

--7.
SELECT CLASS_NAME, DEPARTMENT_NAME
FROM TB_CLASS
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO);

--8.
SELECT CLASS_NAME, PROFESSOR_NAME
FROM TB_CLASS_PROFESSOR
JOIN TB_CLASS USING(CLASS_NO)
JOIN TB_PROFESSOR USING(PROFESSOR_NO);

--9.
SELECT CLASS_NAME, PROFESSOR_NAME
FROM TB_CLASS_PROFESSOR
JOIN TB_CLASS USING(CLASS_NO)
JOIN TB_PROFESSOR USING(PROFESSOR_NO)
WHERE CLASS_NO IN (
	SELECT CLASS_NO FROM TB_CLASS 
	WHERE DEPARTMENT_NO IN (
		SELECT DEPARTMENT_NO 
		FROM TB_DEPARTMENT 
		WHERE CATEGORY ='인문사회'))
ORDER BY CLASS_NAME;

-- 선생님 풀이
SELECT CLASS_NAME, PROFESSOR_NAME
FROM TB_CLASS
JOIN TB_CLASS_PROFESSOR USING(CLASS_NO)
JOIN TB_PROFESSOR P USING(PROFESSOR_NO)
JOIN TB_DEPARTMENT D ON(P.DEPARTMENT_NO = D.DEPARTMENT_NO)
WHERE CATEGORY ='인문사회';

--10.
SELECT STUDENT_NO 학번, STUDENT_NAME "학생 이름", ROUND(AVG(POINT),1) "전체 평점"
FROM TB_GRADE
JOIN TB_STUDENT USING(STUDENT_NO)
WHERE DEPARTMENT_NO = (
	SELECT DEPARTMENT_NO
	FROM TB_DEPARTMENT
	WHERE DEPARTMENT_NAME = '음악학과')
GROUP BY STUDENT_NO, STUDENT_NAME
ORDER BY STUDENT_NO;

SELECT STUDENT_NO 학번, STUDENT_NAME "학생 이름", ROUND(AVG(POINT),1) "전체 평점"
FROM TB_GRADE
JOIN TB_STUDENT USING(STUDENT_NO)
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
WHERE DEPARTMENT_NAME = '음악학과'
GROUP BY STUDENT_NO, STUDENT_NAME
ORDER BY STUDENT_NO;

--11.
SELECT DEPARTMENT_NAME, STUDENT_NAME, PROFESSOR_NAME
FROM TB_STUDENT
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
JOIN TB_PROFESSOR ON(PROFESSOR_NO = COACH_PROFESSOR_NO)
WHERE STUDENT_NO = 'A313047';

--12. 
SELECT STUDENT_NAME, TERM_NO
FROM TB_GRADE
JOIN TB_STUDENT USING(STUDENT_NO)
WHERE CLASS_NO = (
	SELECT CLASS_NO
	FROM TB_CLASS
	WHERE CLASS_NAME = '인간관계론')
AND SUBSTR(TERM_NO, 1, 4) = '2007';

--13.
SELECT CLASS_NAME, DEPARTMENT_NAME
FROM TB_CLASS
LEFT JOIN TB_CLASS_PROFESSOR USING(CLASS_NO)
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
WHERE PROFESSOR_NO IS NULL
AND DEPARTMENT_NO IN (
	SELECT DEPARTMENT_NO
	FROM TB_DEPARTMENT
	WHERE CATEGORY = '예체능');

SELECT CLASS_NAME, DEPARTMENT_NAME
FROM TB_CLASS
LEFT JOIN TB_CLASS_PROFESSOR USING(CLASS_NO)
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
WHERE CATEGORY = '예체능'
AND PROFESSOR_NO IS NULL;

--14. 왜 ORA-00918: column ambiguously defined으로 department_no별칭 필요한지?
SELECT STUDENT_NAME 학생이름, NVL(PROFESSOR_NAME, '지도교수 미지정') 지도교수
FROM TB_STUDENT S
LEFT JOIN TB_PROFESSOR ON(COACH_PROFESSOR_NO = PROFESSOR_NO)
WHERE S.DEPARTMENT_NO = (
	SELECT DEPARTMENT_NO
	FROM TB_DEPARTMENT
	WHERE DEPARTMENT_NAME ='서반아어학과')
ORDER BY STUDENT_NO ;

SELECT STUDENT_NAME 학생이름, NVL(PROFESSOR_NAME, '지도교수 미지정') 지도교수
FROM TB_STUDENT
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
LEFT JOIN TB_PROFESSOR ON(COACH_PROFESSOR_NO = PROFESSOR_NO)
WHERE DEPARTMENT_NAME = '서반아어학과'
ORDER BY STUDENT_NO;

--15
SELECT STUDENT_NO 학번, STUDENT_NAME 이름, DEPARTMENT_NAME "학과 이름", AVG(POINT) 평점
FROM TB_STUDENT
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
JOIN TB_GRADE USING(STUDENT_NO) 
WHERE ABSENCE_YN = 'N'
GROUP BY STUDENT_NO, STUDENT_NAME, DEPARTMENT_NAME
HAVING AVG(POINT) >= 4
ORDER BY 학번;

--16
SELECT CLASS_NO, CLASS_NAME, 평점
FROM(
	SELECT CLASS_NO, DEPARTMENT_NO, TRUNC(AVG(POINT),8) 평점
	FROM TB_GRADE
	JOIN TB_CLASS USING(CLASS_NO)
	WHERE CLASS_TYPE != '논문지도'
	GROUP BY CLASS_NO, DEPARTMENT_NO
	HAVING DEPARTMENT_NO = (
		SELECT DEPARTMENT_NO 
		FROM TB_DEPARTMENT
		WHERE DEPARTMENT_NAME = '환경조경학과'))
JOIN TB_CLASS USING(CLASS_NO)
ORDER BY CLASS_NO;

--17.
SELECT STUDENT_NAME, STUDENT_ADDRESS
FROM TB_STUDENT
WHERE DEPARTMENT_NO = (
	SELECT DEPARTMENT_NO 
	FROM TB_STUDENT
	WHERE STUDENT_NAME = '최경희');

--18.
SELECT STUDENT_NO, STUDENT_NAME
FROM(
	SELECT STUDENT_NO, STUDENT_NAME, AVG(POINT) 평점
	FROM TB_GRADE
	JOIN TB_STUDENT USING(STUDENT_NO)
	WHERE DEPARTMENT_NO = (
		SELECT DEPARTMENT_NO
		FROM TB_DEPARTMENT
		WHERE DEPARTMENT_NAME = '국어국문학과')
	GROUP BY STUDENT_NO, STUDENT_NAME
	ORDER BY 평점 DESC)
WHERE ROWNUM = 1;

SELECT STUDENT_NO, STUDENT_NAME
FROM(
	SELECT STUDENT_NO, STUDENT_NAME, AVG(POINT) 평점
	FROM TB_GRADE
	JOIN TB_STUDENT USING(STUDENT_NO)
	JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
	WHERE DEPARTMENT_NAME = '국어국문학과'
	GROUP BY STUDENT_NO, STUDENT_NAME
	ORDER BY 평점 DESC)
WHERE ROWNUM = 1;

--19.
SELECT DEPARTMENT_NAME "계열 학과명", 전공평점
FROM(
	SELECT DEPARTMENT_NO, ROUND(AVG(POINT),1) 전공평점
	FROM TB_GRADE
	JOIN TB_CLASS USING(CLASS_NO)
	WHERE CLASS_TYPE LIKE '전공%'
	GROUP BY DEPARTMENT_NO)
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
WHERE CATEGORY = (
	SELECT CATEGORY
	FROM TB_DEPARTMENT
	WHERE DEPARTMENT_NAME ='환경조경학과')
ORDER BY "계열 학과명";

-- 선생님 풀이
SELECT DEPARTMENT_NAME "계열 학과명", ROUND(AVG(POINT),1) 전공평점
FROM TB_DEPARTMENT
JOIN TB_CLASS USING(DEPARTMENT_NO)
JOIN TB_GRADE USING(CLASS_NO)
WHERE CATEGORY = (
	SELECT CATEGORY
	FROM TB_DEPARTMENT
	WHERE DEPARTMENT_NAME = '환경조경학과')
AND CLASS_TYPE LIKE '전공%'
GROUP BY DEPARTMENT_NAME
ORDER BY 1;
