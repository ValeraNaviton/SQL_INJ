<%
    if ((session.getAttribute("userName") == null) || (session.getAttribute("userName") == "")) {
%>
loxin failed<br/>
<a href="index.jsp">Please Login</a>
<%} else {
%>
Welcome <%=session.getAttribute("userName")%>, you are loxed in
<a href='logout.jsp'>Log out</a>
<%
    }
%>
