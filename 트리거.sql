-- TRIGGER(트리거)
/*
    - 테이블이나 뷰가 INSERT, UPDATE, DELETE 등의 DML문에 의해 변경될 경우(테이블 이벤트 발생 시)
      자동으로(묵시적으로) 실행될 내용을 정의하여 저장하는 객체(PROCEDURE)  
*/


-- 트리거 종류
/*
    - SQL문의 실행 시기에 따른 분류
        BEFORE TRIGGER : SQL문 실행 전 트리거 실행
        AFTER TRIGGER  : SQL문 실해 후 트리거 실행
        
    - SQL문의 의해 영향을 받는 각 ROW에 따른 분류
        ROW TRIGGER    : SQL문 각 ROW에 대해 한번씩 실행
                         트리거 생성 시 FOR EACH ROW 옵션 작성 
                         :OLD   : 참조 전 열의 값(INSERT: 입력 전 자료, UPDATE : 수정 전 자료, DELETE : 삭제할 자료)
                         :NEW   : 참조 후 열의 값(INSERT : 입력 할 자료, UPDATE : 수정 할 자료)
        STATMENT TRIGGER : SQL문에 대해 한번만 실행(DEFAULT TRIGGER)

*/


-------------------------------------------------------------------------------------------------------------------- 


-- 트리거 생성
/*
    [표현식]
    CREATE [OR REPLACE] TRIGGER 트리거명
    BEFORE | AFTER 
    INSERT | UPDATE | DELETE
    ON 테이블명
    [FOR EACH ROW] -- ROW TRIGGER 옵션
    [WHEN  조건]
    
    DECLARE
        -- 선언부
    BEGIN
        -- 실행부
    [EXCEPTION]
    END;
    /
*/

-- EMPLOYEE 테이블에 INSERT후 메세지 출력
CREATE OR REPLACE TRIGGER TRG_01
AFTER INSERT
ON EMPLOYEE
BEGIN  
    DBMS_OUTPUT.PUT_LINE('신입사원이 입사했습니다.');
END;
/

COMMIT;


INSERT INTO EMPLOYEE
VALUES(905,'길성춘','690512-1151432','gil_sj@kh.or.kr','01035464455',
       'D5','J3','S5',3000000,0.1,200,SYSDATE,NULL,DEFAULT); 
       
ROLLBACK;
       
       
       
-- 예시용 테이블/시퀀스 생성
-- 상품 정보 테이블
CREATE TABLE PRODUCT(
    PCODE NUMBER PRIMARY KEY,   -- 상품 코드
    PNAME VARCHAR2(30),         -- 상품명
    BRAND VARCHAR2(30),         -- 브랜드
    PRICE NUMBER,               -- 가격
    STOCK NUMBER DEFAULT 0      -- 재고
);

-- 상품 입출고 상세 이력 테이블
CREATE TABLE PRO_DETAIL(
    DCODE NUMBER PRIMARY KEY,       -- 상세 코드
    PCODE NUMBER,                   -- 상품 코드
    PDATE DATE,                     -- 상품 입고일
    AMOUNT NUMBER,                  -- (입고/출고)개수
    STATUS VARCHAR2(10) CHECK(STATUS IN('입고', '출고')),   -- 상품 상태(입고, 출고)
    FOREIGN KEY(PCODE) REFERENCES PRODUCT(PCODE)
);

CREATE SEQUENCE SEQ_PCODE;
CREATE SEQUENCE SEQ_DCODE;

INSERT INTO PRODUCT
VALUES(SEQ_PCODE.NEXTVAL, '갤럭스10', '삼송', 900000, DEFAULT);

INSERT INTO PRODUCT
VALUES(SEQ_PCODE.NEXTVAL, '아이뽀X', '사과', 1000000, DEFAULT);

INSERT INTO PRODUCT
VALUES(SEQ_PCODE.NEXTVAL, '대륙폰', '샤우미', 600000, DEFAULT);

SELECT * FROM PRODUCT;
SELECT * FROM PRO_DETAIL;


-- PRO_DETAIL 테이블에 데이터 삽입(INSERT)시
-- STATUS컬럼 값의 따른 PRODUCT테이블 STOCK 컬럼 값 변경 트리거 생성
CREATE OR REPLACE TRIGGER TRG_02
AFTER INSERT ON PRO_DETAIL
FOR EACH ROW -- ROW TRIGGER 명시
    BEGIN        
        -- 상품이 입고된 경우
        IF :NEW.STATUS = '입고' -- :NEW.STATUS  : SQL 반영 후 STATUS 컬럼의 값
        THEN
            -- PRODUCT 테이블에서 상품코드(PCODE)가 같은 상품의 재고량 증가
            UPDATE PRODUCT SET STOCK = STOCK + :NEW.AMOUNT
            WHERE PCODE = :NEW.PCODE;
        END IF;
        -- 상품이 출고된 경우
        IF :NEW.STATUS = '출고'
        THEN
            -- PRODUCT 테이블에서 상품코드(PCODE)가 같은 상품의 재고량 감소
            UPDATE PRODUCT SET STOCK = STOCK - :NEW.AMOUNT
            WHERE PCODE = :NEW.PCODE;
        END IF;
END;
/


SELECT * FROM PRODUCT;

-- PCODE = 1인 상품 5개 입고
INSERT INTO PRO_DETAIL VALUES(SEQ_DCODE.NEXTVAL, 1, SYSDATE, 5, '입고');

SELECT * FROM PRO_DETAIL;
SELECT * FROM PRODUCT; -- PCODE = 1 상품의 STOCK 컬럼 값이 5로 증가함을 확인


INSERT INTO PRO_DETAIL VALUES(SEQ_DCODE.NEXTVAL, 2, SYSDATE, 10, '입고');
INSERT INTO PRO_DETAIL VALUES(SEQ_DCODE.NEXTVAL, 3, SYSDATE, 20, '입고');
INSERT INTO PRO_DETAIL VALUES(SEQ_DCODE.NEXTVAL, 1, SYSDATE, 1, '출고');
INSERT INTO PRO_DETAIL VALUES(SEQ_DCODE.NEXTVAL, 2, SYSDATE, 7, '출고');
INSERT INTO PRO_DETAIL VALUES(SEQ_DCODE.NEXTVAL, 3, SYSDATE, 11, '출고');

SELECT * FROM PRO_DETAIL;
SELECT * FROM PRODUCT;

COMMIT;