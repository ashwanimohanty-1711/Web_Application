<jsp:useBean id="context" scope="session" class="com.navisys.fo.SessionControl"/>
<jsp:useBean id="user" scope="session" class="com.navisys.fo.UserControl">
  <% user.setSessionControl(context); %>
</jsp:useBean>
<jsp:useBean id="login" scope="session" class="com.navisys.fo.LoginControl">
  <% login.setSessionControl(context); %>
</jsp:useBean>
<jsp:useBean id="product" scope="session" class="com.navisys.fo.ProductControl">
  <% product.setSessionControl(context); %>
</jsp:useBean>
<jsp:useBean id="policy" scope="session" class="com.navisys.fo.PolicyControl">
	<% policy.setSessionControl(context); %>
</jsp:useBean>
<jsp:useBean id="app" scope="session" class="com.navisys.fo.AppControl" >
<% app.setSessionControl(context); %>
</jsp:useBean>
<%@ include file="../../include/common.inc"%>
<%@ page import="com.navisys.util.DateUtil"%>
<%@ page import="ei.SunGeneralInfoData"%>
<%@ page import="ei.ExemptionIndicator"%>
<%@ page import="java.util.List"%>

　
<%
	if ( !user.CanAccess(ACCT_INFO_MODIFY) ) /* SCR59449 */
	{
		response.sendRedirect(LANG_ROOT);
		return;
	}

	String errorMessage = "";
	boolean showResults = false;
	boolean LineDrawRequired = true;
	NumberFormat f = NumberFormat.getInstance();
	f.setMaximumIntegerDigits(12);
	f.setMinimumFractionDigits(2);
	f.setGroupingUsed(true);
	
	String csiStartdate="";
	String csiEnddate="";
	String csiStartMM = "01";
	String csiStartDD = "01";
	String csiStartYY = "1900";
	String csiEndMM = "12";
	String csiEndDD = "31";
	String csiEndYY = "2999";
	Date startdate = null;
	Date enddate = null;
	Date currentDate = null;
	List<ExemptionIndicator> resultsList = null;
	String sDate = DateUtil.toUSDate(new Date());
	List<ExemptionIndicator> csiDescList = null;
	String csiTypeVal ="";
	String selectedCSInd ="";
	String polCont="";
	String reqMsg="";
	String sMessage = ""; 
	
	currentDate = DateUtil.toDate(sDate);

	csiStartMM = (request.getParameter("csiStartMM") == null) ? "" : request.getParameter("csiStartMM");
	csiStartDD = (request.getParameter("csiStartDD") == null) ? "" : request.getParameter("csiStartDD");
	csiStartYY = (request.getParameter("csiStartYY") == null) ? "" : request.getParameter("csiStartYY");

	if("".equals(csiStartMM))
		csiStartMM = ""+DateUtil.getMonth(sDate);
	if("".equals(csiStartDD))
		csiStartDD = ""+DateUtil.getDay(sDate);
	if("".equals(csiStartYY))
		csiStartYY = ""+DateUtil.getYear(sDate);

	csiStartMM = (csiStartMM.length() > 1) ? csiStartMM : "0" + csiStartMM;
	csiStartDD = (csiStartDD.length() > 1) ? csiStartDD : "0" + csiStartDD;

	csiStartdate = csiStartYY + "" + csiStartMM + "" + csiStartDD;

	csiEndMM = (request.getParameter("csiEndMM") == null) ? "12" : request.getParameter("csiEndMM");
	csiEndDD = (request.getParameter("csiEndDD") == null) ? "31" : request.getParameter("csiEndDD");
	csiEndYY = (request.getParameter("csiEndYY") == null) ? "2999" : request.getParameter("csiEndYY");

	csiEndMM = (csiEndMM.length() > 1) ? csiEndMM : "0" + csiEndMM;
	csiEndDD = (csiEndDD.length() > 1) ? csiEndDD : "0" + csiEndDD;

	csiEnddate = csiEndYY + "" + csiEndMM + "" + csiEndDD;
	
	polCont = policy.getPolicyNumber();

	
	//ei.SunGeneralInfoData sgInfo = app.getGeneralInfo();//S_5249
	

	csiDescList = (java.util.ArrayList<ExemptionIndicator>) policy.getExemDesc();
	String csiIndicator = "";
	java.util.List<ExemptionIndicator>	csiHistList = new java.util.ArrayList<ExemptionIndicator>();
	if(!polCont.equals("") || polCont != null)
	{
		csiHistList = policy.getExemHistData(polCont);
	
	}
	for(ExemptionIndicator csiIndi : csiHistList) 
	{
		if("12/31/2999".equals(csiIndi.eEndDate))
		{	
			csiIndicator = csiIndi.exemInd+"";
			break;
		}
	}
	
	csiTypeVal = csiIndicator;
	selectedCSInd = (request.getParameter("csiHistType") == null) ? "" : request.getParameter("csiHistType");

　
	if (request.getMethod().equalsIgnoreCase("post")) {
		if (request.getParameter("update.x") != null) {
			csiTypeVal = request.getParameter("csiHistType") != null ? request.getParameter("csiHistType") : csiIndicator;
			if (DateUtil.isDateValid(csiStartdate)) {
				startdate = DateUtil.toDate(csiStartdate);
			} else {
				errorMessage += "Start Date provided was invalid.\n";
			}

			if (DateUtil.isDateValid(csiEnddate)) {
				enddate = DateUtil.toDate(csiEnddate);

			} else {
				errorMessage += "End Date provided was invalid.\n";
			}

			if (startdate != null && enddate != null) {
				if (startdate.after(enddate))
					errorMessage += "Start Date cannot be after End Date.\n";

			}

			if (errorMessage.equals("")) {
				System.out.println("U r inside Update-");
				CharSequence cs1 = "Sucessfully";
				System.out.println("SELECTED--Exem_____"+selectedCSInd+"STDATE"+csiStartdate+"ENDDATE"+csiEnddate+"CONT__"+polCont);
				if(!(csiTypeVal).equals(request.getParameter("csiHidden")))
				  {
										
					reqMsg = policy.setExemUpdateList(polCont, selectedCSInd, csiStartdate, csiEnddate);
				  }
				else
				{
					reqMsg ="Please change the Commission Indicator.";
				}
				
				
				System.out.println("RRR----"+reqMsg);
				if(!reqMsg.contains(cs1))
				{
					errorMessage +=reqMsg;
					System.out.println("RRRMMM___----"+reqMsg);
				}
				if ( errorMessage == null || errorMessage.isEmpty() )
				{
					policy.setContactHistoryMessage( MessageCodeConstants.NEW_ISSUE_EXEM_IND_UPD );
					sMessage +="Commission Indicator modified successfully.";
					response.sendRedirect("AccountCommissionInd.jsp?msg=" + sMessage);
					return;
						
				}
				
			}
		}
	}
%>
<!doctype html public "-//w3c//dtd html 3.2 final//en">
<html>
<head>
	<%@ include file="../include/datetabber.inc"%>
	<%@ page import="com.navisys.fo.contact.message.codes.MessageCodeConstants" %><%/*5249*/%>
	<script src="../include/calendar_v11.js"></script>
	<script language="javascript">

	</script>
	<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
	<title>Commission Suppression History</title>
	<link rel="stylesheet" href="../css/<%=user.getStylesheet()%>">
	<%
		mainTab = ACCTS_LST_GEN_VIEW;
		subTab = ACCT_INFO_MODIFY;
	%>
</head>
<body bgcolor="#cccccc" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script language="JavaScript">

function deleteCommRowGen(thisObject)
{
	 var table = document.getElementById('commissionAddNewRowID');
	 table.firstChild.removeChild(thisObject.parentNode.parentNode);
}

</script>
<%@ include file="../include/Header.inc"%>
<%@ include file="../include/tabs.inc"%>

<!-- Begin Light Orange Area -->
<table border="0" cellpadding="0" cellspacing="0" width="100%">
 <tr>
	<td bgcolor="#ffcc66"><img src="<%=LANG_ROOT%><%=newImages%>/spacer.gif" alt="" border="0" width="5" height="30"></td>
	<td bgcolor="#ffcc66" class="tabletextblack"><b>Commission Suppression History</b></td>
	<td bgcolor="#ffcc66"><img src="<%=LANG_ROOT%><%=newImages%>/spacer.gif" alt="" border="0" width="300" height="30"></td>
	<td bgcolor="#ffcc66"><img src="<%=LANG_ROOT%><%=newImages%>/spacer.gif" alt="" border="0" width="150" height="30"></td>
	<td bgcolor="#ffcc66"></td>
	<td bgcolor="#ffcc66" align="right" >&nbsp;</td>
	<td bgcolor="#ffcc66"><img src="<%=LANG_ROOT%><%=newImages%>/spacer.gif" alt="" border="0" width="1" height="20"></td>
	<td bgcolor="#ffcc66" align="right" >&nbsp;</td>
	<td bgcolor="#ffcc66" align="right">
	</td>
	</tr>
		  <%
       if( ! "".equals(errorMessage) )
       {
		%>
          <tr>
          <td colspan=5 class="tabletextblack"><ul><%=sWarning%>
                  <span class="ErrorMessage"><%=errorMessage %><BR>
                     </span></ul>
           </td>
         </tr>
		<%
       		}
		%>
</table>
<!-- END Light Orange Area -->
<!-- Begin Main Content table -->
<table cellSpacing=0 cellPadding=0 width="100%" bgColor=#ffffff border=0>
<tbody>

<tr>

		<table cellSpacing=0 cellPadding=0 width="100%" border=0>
		<tbody>
		<tr>
			<td width=-1% bgColor=#999999><IMG height=25 alt="" src="<%=LANG_ROOT%><%=newImages%>/spacer.gif" width=1 border=0></td>
			<td bgColor=#999999><IMG height=1 alt="" src="<%=LANG_ROOT%><%=newImages%>/spacer.gif" width=1 border=0></td>
			<td class=tabletextwhite width="100%" bgColor=#999999><B></B></td>
			<td bgColor=#999999><IMG height=1 alt="" src="<%=LANG_ROOT%><%=newImages%>/spacer.gif" width=1 border=0></td>
			<td width=-1% bgColor=#999999><IMG height=1 alt="" src="<%=LANG_ROOT%><%=newImages%>/spacer.gif" width=1 border=0></td>
		</tr> 
		<tr>
		<td width=-1% bgColor=#999999><IMG height=1 alt="" src="<%=LANG_ROOT%><%=newImages%>/spacer.gif" width=1 border=0></td>
		<td><IMG height=1 alt="" src="<%=LANG_ROOT%><%=newImages%>/spacer.gif" width=1 border=0></td>
		<td class=tabletextblack vAlign=top>
		<FORM NAME="AccountCommissionInd" METHOD="post" ACTION="AccountCommissionInd.jsp">
			<table cellSpacing=1 cellPadding=1 width="100%" bgColor=#ffffff border="0">
			<tbody>
			<tr>
				<td width="16%"><IMG height=1 alt="" src="<%=LANG_ROOT%><%=newImages%>/spacer.gif" width=150 border=0></td>
				<td width="16%"><IMG height=1 alt="" src="<%=LANG_ROOT%><%=newImages%>/spacer.gif" width=100 border=0></td>
				<TD width="10%"><IMG height=1 alt="" src="<%=LANG_ROOT%><%=newImages%>/spacer.gif" width=100 border=0></TD>
				<TD width="12%"><IMG height=1 alt="" src="<%=LANG_ROOT%><%=newImages%>/spacer.gif" width=100 border=0></TD>
				<TD width="4%"><IMG height=1 alt="" src="<%=LANG_ROOT%><%=newImages%>/spacer.gif"  width=100 border=0></TD>
				<TD width="42%"><IMG height=1 alt="" src="<%=LANG_ROOT%><%=newImages%>/spacer.gif" width=100 border=0></TD>
			</tr>

			<br><br>
			<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>
			<tr>
				
				<td class=tabletextblack width="30%">Commission Suppression Indicator &nbsp;&nbsp;<!-- Exem Indicator //-->
				
				<select id="csiHistType" <%-- <%=disableExem %> --%> name="csiHistType" class="tabletextblack">
				<%
					String selectedCSI = "";
					for (ExemptionIndicator csiDetails : csiDescList) {
						selectedCSI = "";
						if (csiTypeVal.equals(csiDetails.exemId+"")) {
							selectedCSI = "selected";
							
						}
				%>
				<option <%=selectedCSI%> value="<%=csiDetails.exemId%>"><%=csiDetails.exemDesc%></option>
				<%
					}
				%>
		</select>
				
				</td>
			
				<td class=tabletextblack width="25%">Effective Date&nbsp;&nbsp;<!-- START DATE //-->
				<INPUT class=tabletextblack onkeydown=KeyDown(this,event); onkeyup=KeyPress(this,event); onfocus=gotFocus(this); maxLength=2 size=2 value="<%= csiStartMM %>" name=csiStartMM> /
				<INPUT class=tabletextblack onkeydown=KeyDown(this,event); onkeyup=KeyPress(this,event); onfocus=gotFocus(this); maxLength=2 size=2 value="<%= csiStartDD %>" name=csiStartDD> /
				<INPUT class=tabletextblack onkeydown=KeyDown(this,event); onkeyup=KeyPress(this,event); onfocus=gotFocus(this); maxLength=4 size=4 value="<%= csiStartYY %>" name=csiStartYY>
				<A onclick="g_Calendar.show(this, AccountCommissionInd.csiStartMM, AccountCommissionInd.csiStartDD, AccountCommissionInd.csiStartYY)" href="javascript:void(0);">
				<IMG height=20 alt=Calendar src="<%=LANG_ROOT%><%=newImages%>/calendar_v02.gif" width=23 border=0> </A>
				</td>
				
				<td class=tabletextblack width="25%">End Date&nbsp;&nbsp;<!-- END DATE //-->
				<INPUT class=tabletextblack onkeydown=KeyDown(this,event); onkeyup=KeyPress(this,event); onfocus=gotFocus(this); maxLength=2 size=2 value="<%= csiEndMM %>" name=csiEndMM disabled> /
				<INPUT class=tabletextblack onkeydown=KeyDown(this,event); onkeyup=KeyPress(this,event); onfocus=gotFocus(this); maxLength=2 size=2 value="<%= csiEndDD %>" name=csiEndDD disabled> /
				<INPUT class=tabletextblack onkeydown=KeyDown(this,event); onkeyup=KeyPress(this,event); onfocus=gotFocus(this); maxLength=4 size=4 value="<%= csiEndYY %>" name=csiEndYY disabled>
				<A onclick="g_Calendar.show()" href="javascript:void(0);">
				<IMG height=20 alt=Calendar src="<%=LANG_ROOT%><%=newImages%>/calendar_v02.gif" width=23 border=0> </A>
				</td>
				
				<td > 
				<input type="image" name="update" src="<%=LANG_ROOT%><%=newImages%>/b_update_o_006699.gif" alt="Update" name="SubmitChange" value="Submit" border="0" width="79" height="19" align="middle">
				</td>
				
				</tr>
				<input type="hidden" name="csiHidden" value="<%=csiIndicator%>" >
				<td><IMG height=1 alt="" src="<%=LANG_ROOT%><%=newImages%>/spacer.gif" width=1 border=0></td>
				</tr>
				<tr>
				<td colSpan=3><IMG height=10 alt="" src="<%=LANG_ROOT%><%=newImages%>/spacer.gif" width=1 border=0></td>
				</tr>
				</tbody>
				</table>

	<TD width=0% bgColor=#999999><IMG height=1 alt="" src="<%=LANG_ROOT%><%=newImages%>/spacer.gif" width=1 border=0></TD>
	</TR>
	<TR>
	<TD bgColor=#999999 colSpan=7><IMG height=1 alt="" src="<%=LANG_ROOT%><%=newImages%>/spacer.gif" width=1 border=0></TD></TR></TBODY></TABLE></TD>
	<TD height=182><IMG height=1 alt="" src="<%=LANG_ROOT%><%=newImages%>/spacer.gif" width=1 border=0></TD>
	</TR>
	<TR>
	<TD height=2><IMG height=20 alt="" src="<%=LANG_ROOT%><%=newImages%>/spacer.gif" width=8 border=0></TD>
	<TD height=2>&nbsp;</TD>
	<TD height=2>&nbsp;</TD>
	</TR>
	</TBODY>
	</TABLE>
	
	
	
	<!-- Begin Main Content Table NEW JSP-->
	
            <table cellSpacing=1 cellPadding=0.5 width="60%"  bgColor=#ffffff border=0 id="commissionAddNewRowID">
	<tr><td nowrap class="tabletextblack"><b></b></td></tr>
<tr>
<th  bgcolor="#999999" class="tabletextwhite" align="center"><b>Suppression Indicator </b></th>
<th bgcolor="#ffffff"><img src="<%=LANG_ROOT%><%=newImages%>/spacer.gif" alt="" border="0" width="0" height="25"></th>
<th  bgcolor="#999999" class="tabletextwhite" align="center"><b>Effective Date</b></th>
<th bgcolor="#ffffff"><img src="<%=LANG_ROOT%><%=newImages%>/spacer.gif" alt="" border="0" width="0" height="1"></th>
<th  bgcolor="#999999" class="tabletextwhite" align="center"><b>End Date</b></th>
<th bgcolor="#ffffff"><img src="<%=LANG_ROOT%><%=newImages%>/spacer.gif" alt="" border="0" width="0" height="1"></th>
<th  bgcolor="#999999" class="tabletextwhite" align="center"><b>System Date</b></th>

</tr>
<%
if(csiHistList != null && csiHistList.size()>0)
{
	for(int i=0;i<csiHistList.size();i++)
	{
		ExemptionIndicator nmInd = csiHistList.get(i);
%>
<tr>

 <%
                      
		                     for (ExemptionIndicator csiDetails : csiDescList)
		             		{
		                    	
		             		 if ((nmInd.exemInd).equals(csiDetails.exemId+""))
		             		 {
		             			%> 
		             			 <td nowrap class="tabletextblack"  align="center"> &nbsp;&nbsp;<%=csiDetails.exemDesc%><br></td>
		             			
		             			 <%
		             			 System.out.println("Veri%%%%%"+csiDetails.exemDesc); 
		             		 }
		             		 else
		             		 {
		             			 System.out.println("VeriElse%%%%%"+csiDetails.exemDesc);
		             		 }
		             	 }
                    	
                     %>
<td bgcolor="#ffffff"><img src="<%=LANG_ROOT%><%=newImages%>/spacer.gif" alt="" border="0" width="0" height="25"></td> 
 <td nowrap class="tabletextblack"  align="center">&nbsp;&nbsp;<%= DateUtil.toUSDate( nmInd.sStartDate) %></td>
<td bgcolor="#ffffff"><img src="<%=LANG_ROOT%><%=newImages%>/spacer.gif" alt="" border="0" width="0" height="1"></td>
  <td nowrap class="tabletextblack"  align="center"> &nbsp;&nbsp;<%= DateUtil.toUSDate(nmInd.eEndDate) %></td>
<td bgcolor="#ffffff"><img src="<%=LANG_ROOT%><%=newImages%>/spacer.gif" alt="" border="0" width="0" height="1"></td>
 <td nowrap class="tabletextblack"  align="center"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%= DateUtil.toUSDate(nmInd.systemDate) %> </td>
 <td bgcolor="#ffffff"><img src="<%=LANG_ROOT%><%=newImages%>/spacer.gif" alt="" border="0" width="0" height="1"></td>
 

<td align="center"><a href="javascript:void(0);" id="editCommInd" onclick="editCommRowGen(this);">Edit</a></td>
 <td bgcolor="#ffffff"><img src="<%=LANG_ROOT%><%=newImages%>/spacer.gif" alt="" border="0" width="0" height="1"></td>
 
<!--  <td align="center"><a href="javascript:void(0);" id="addNewRestDelete" onclick="deleteBrokerRowGen(this);">Delete</a></td> -->
 <td align="center"><a href="javascript:void(0);" id="deleteCommInd" onclick="deleteCommRowGen(this);">Delete</a></td>
 <td bgcolor="#ffffff"><img src="<%=LANG_ROOT%><%=newImages%>/spacer.gif" alt="" border="0" width="0" height="1"></td>

</tr>
<%}
	}	
	else 
	{%>
<tr>
 <td nowrap style='font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 11px; color: red; text-decoration: none;' align="center">&nbsp;&nbsp;</td>
<td bgcolor="#ffffff"><img src="<%=LANG_ROOT%><%=newImages%>/spacer.gif" alt="" border="0" width="0" height="1"></td>
  <td nowrap style='font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 11px; color: red; text-decoration: none;' align="center"> &nbsp;&nbsp;</td>
<td bgcolor="#ffffff"><img src="<%=LANG_ROOT%><%=newImages%>/spacer.gif" alt="" border="0" width="0" height="1"></td>
 <td nowrap style='font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 11px; color: red; text-decoration: none;' align="center"> &nbsp;&nbsp;</td>
<td bgcolor="#ffffff"><img src="<%=LANG_ROOT%><%=newImages%>/spacer.gif" alt="" border="0" width="0" height="1"></td>
 <td nowrap style='font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 11px; color: red; text-decoration: none;' align="center"> &nbsp;&nbsp;</td>

 </tr>
	<%}
		 %>
</table>

	<!-- End Main Content Table New JSP-->
	
	

<!-- Begin Footer -->
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					
      <td bgcolor="#006699" width="0%"><img src="<%=LANG_ROOT%><%=newImages%>/spacer.gif" alt="" border="0" width="1" height="30"></td>
					
      <td bgcolor="#006699" class="tabletextblack" width="30%"> </td>
      <td bgcolor="#006699" width="0%"><img src="<%=LANG_ROOT%><%=newImages%>/spacer.gif" alt="" border="0" width="1" height="30"></td>
					
          
     <%--  <td bgcolor="#006699" align="right" width="69%"> <A href="javascript:window.history.go(-1);"><IMG alt=Back border=0 height=19 src="<%=LANG_ROOT%><%=newImages%>/b_back_blue.gif" width=79 align="middle"></A> 
		<input type="image" name="update" src="<%=LANG_ROOT%><%=newImages%>/b_update_o_006699.gif" alt="Update" name="SubmitChange" value="Submit" border="0" width="79" height="19" align="middle">
						</td> --%>
					
      <td bgcolor="#006699" width="1%"><img src="<%=LANG_ROOT%><%=newImages%>/spacer.gif" alt="" border="0" width="10" height="30"></td>
				</tr>
			</table>
</FORM>
	<!--- End Footer -->
<%@ include file="../include/copyright.inc"%>
</body>
</html>
