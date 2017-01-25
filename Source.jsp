<%@page import="java.util.Collections"%>
<%@page import="java.util.LinkedList,java.util.Set,java.util.HashSet"%>
<%@page import="java.util.List,java.util.ArrayList,ei.BrokerRestriction,com.navisys.util.DateUtil,java.lang.Integer"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
<jsp:useBean id="app" scope="session" class="com.navisys.fo.AppControl">
<% app.setSessionControl(context); %>
</jsp:useBean>
<%@ include file="../../include/common.inc"%>
<%
String errorMessage = "";
String[] dbErrorMessage = null;
String selectedFeat = "";
String linkTagOpen = "";
String linkTagClose = "";
String codeID1 = "";
String codeID2 = "";
String plnCode = "";

boolean featFlag = false;
boolean duplicateGen = false;
boolean duplicateExp = false;
//Default Broker Dealer
String defBrokerID = "-999";
//Default Start Date
String sMonth = "01";
String sDay = "01";
String sYear = "1900";

//Default end date
String eMonth = "12";
String eDay = "31";
String eYear = "2999";

String systemDeploymentDate = "";
Date genStartDate = null;
Date genEndDate = null;
Date genImplDate = null;

Date expStartDate = null;
Date expEndDate = null;
List<String> productList = null;
List<BrokerRestriction> brFundorFeatList = null;
List<BrokerRestriction> productPlanList = null;
java.util.Map<String, String> brokerDealerMap = null;
List<BrokerRestriction> selectedBrokerList = null;
List<BrokerRestriction> selectedProductList = null;
List<BrokerRestriction> inserBrokerList = null;
List<BrokerRestriction> totalList = new ArrayList<BrokerRestriction>();
List<BrokerRestriction> currentRestrictionList = null;
List<Integer> excepAddProductList = null;
String loginUser = login.getLoginID();
//Submitted Date
java.text.DateFormat sdfDate = new java.text.SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
java.util.Date now = new java.util.Date();
String submittedDate = sdfDate.format(now);

String brRestGenStartmM[] =  null;
String brRestGenStartdD[] =  null;
String brRestGenStartyY[] =  null;
String brRestGenStartDate[] = null;

String brRestGenEndmM[] =  null;
String brRestGenEnddD[] =  null;
String brRestGenEndyY[] =  null;
String brRestGenEndDate[] = null;
String currentExpBD[] = null;

String[] bRStartExpmM = null;
String[] bRStartExpdD = null;
String[] bRStartExpyY = null;
String[] brStartExpDate = null;

String[] bREndExpmM = null;
String[] bREndExpdD = null;
String[] bREndExpyY = null;
String[] brEndExpDate = null;
String[] slCurrentRestrictExp = null;

String prevImplDt = "";
String prevsubBy = "";

//Current Gen Restrictions
String[] slCurrntGenrestrict = null;
String[] bRCurrntStartMM = null;
String[] bRCurrntStartDD = null;
String[] bRCurrntStartYY = null;
String[] cStartDtGen = null;

String[] bRCurrntEndMM = null;
String[] bRCurrntEndDD = null;
String[] bRCurrntEndYY = null;
String[] cEndDtGen = null;

String[] currentGenProduct = null;
String[] currentGenBDID = null;
String cEditGen[] = null;
String cDeleteGen[] = null;

//Current Exp Records
String[] bRCurrntStartExpMM = null;
String[] bRCurrntStartExpDD = null;
String[] bRCurrntStartExpYY = null;
String[] cStartDtExp = null;

String[] bRCurrntEndExpMM = null;
String[] bRCurrntEndExpDD = null;
String[] bRCurrntEndExpYY = null;
String[] cEndDtExp = null;
String cEditExp[] = null;
String cDeleteExp[] = null;
String[] currentExpProduct = null;
List<BrokerRestriction> backList = null;
List<String> sortOrderGen = null;
List<String> sortOrderExp = null;

String strImplDate = "";
java.util.Map<Integer, String> productFamilyMap = null;
String replacePrevSubDt = "";
boolean fundFlag = false; 

String[] currentExpBDID = request.getParameterValues("currentExpBDID");
String slctRestName = request.getParameter("slctRestName")==null?"":request.getParameter("slctRestName");
String genAddRest[]= request.getParameterValues("genRestrict");
String generalBDSelect[] = request.getParameterValues("generalBD");
String generalProductSelect[] = request.getParameterValues("productNameAdNew");
String expRestriction[] = request.getParameterValues("expRestrict");
String expBDSelect[] = request.getParameterValues("exceptionalBD");
String expProductSelect[] = request.getParameterValues("productNameExNew");
String fromBack = request.getParameter("fromBack")==null?"":request.getParameter("fromBack");
String selectedProductName[] =  request.getParameterValues("productName");
String selectedToBdList[] = request.getParameterValues("toBDList");
String productNameFeat = request.getParameter("productNameFeat");
currentGenBDID = request.getParameterValues("currentGenBDID");
String brokerRestrictionSelect = request.getParameter("fundOrFeatOrPlan")==null?"Fund":request.getParameter("fundOrFeatOrPlan");
String productFamily = request.getParameter("productFamily")==null?"0":request.getParameter("productFamily");
String productFamily1 = request.getParameter("productFamily1")==null?"":request.getParameter("productFamily1");
String selectedFundOrFeat = request.getParameter("fundOrFeature")==null?"":request.getParameter("fundOrFeature");
String searchBrokerRest = request.getParameter("searchBrokerRest");
String searchProdFamly = request.getParameter("searchProdFamly");
String searchProdFamly1 = request.getParameter("searchProdFamly1");
String SearchfundOrFeature = request.getParameter("SearchfundOrFeature");
String prevSubmittedDt = request.getParameter("submittedon")==null?"":request.getParameter("submittedon");
strImplDate =  request.getParameter("strImplDate")==null?"":request.getParameter("strImplDate");

String implDate = DateUtil.toUSDate(DateUtil.addDays(new Date(), 1));
String implStartMM = ""+DateUtil.getMonth(implDate);
implStartMM = (implStartMM.length() > 1) ? implStartMM : "0" + implStartMM;
String implStartDD = ""+DateUtil.getDay(implDate);
implStartDD = (implStartDD.length() > 1) ? implStartDD : "0" + implStartDD;
String implStartYY = ""+DateUtil.getYear(implDate);

if(request.getParameter("implStartmM") != null)
{
	System.out.println("Sample Date23444    "+strImplDate);
	implStartMM = (request.getParameter("implStartmM") == null) ? "" : request.getParameter("implStartmM");
	implStartMM = (implStartMM.length() > 1) ? implStartMM : "0" + implStartMM;
	implStartDD = (request.getParameter("implStartdD") == null) ? "" : request.getParameter("implStartdD");
	implStartDD = (implStartDD.length() > 1) ? implStartDD : "0" + implStartDD;
	implStartYY = (request.getParameter("implStartyY") == null) ? "" : request.getParameter("implStartyY");
	System.out.println("implStartMM "+implStartMM+"implStartMM   "+implStartDD);
}
strImplDate = implStartYY + "" + implStartMM + "" + implStartDD;
systemDeploymentDate = strImplDate;

System.out.println("From Back   )))))))))))  "+fromBack);

	if(fromBack.equals("back") || fromBack.equals("rework"))
	{	
		strImplDate = request.getParameter("strImplDate")==null?"":request.getParameter("strImplDate");
		prevImplDt = request.getParameter("strImplDate")==null?"":request.getParameter("strImplDate");
		brokerRestrictionSelect = request.getParameter("fundorfeat")==null?"":request.getParameter("fundorfeat");
		productFamily = request.getParameter("prodFamily")==null?"":request.getParameter("prodFamily");
		productFamily1 = request.getParameter("prodFamily1")==null?"":request.getParameter("prodFamily1");
		codeID1 = request.getParameter("codeid1")==null?"":request.getParameter("codeid1");
		codeID2 = request.getParameter("codeid2")==null?"":request.getParameter("codeid2");
		
		if("Feature".equals(brokerRestrictionSelect))
		{
			productNameFeat = request.getParameter("planCode")==null?"":request.getParameter("planCode");
			if(productNameFeat.equals(""))
				productNameFeat = request.getParameter("prodfeat")==null?"":request.getParameter("prodfeat");
		}
		else
			productNameFeat = "";
		
		if(!"".equals(strImplDate) && strImplDate != null)
		{
			implStartMM = ""+DateUtil.getMonth(strImplDate);
			implStartMM = (implStartMM.length() > 1) ? implStartMM : "0" + implStartMM;
			implStartDD = ""+DateUtil.getDay(strImplDate);
			implStartDD = (implStartDD.length() > 1) ? implStartDD : "0" + implStartDD;
			implStartYY = ""+DateUtil.getYear(strImplDate);
		}
		else
		{
			implDate = DateUtil.toUSDate(DateUtil.addDays(new Date(), 1));
			implStartMM = ""+DateUtil.getMonth(implDate);
			implStartMM = (implStartMM.length() > 1) ? implStartMM : "0" + implStartMM;
			implStartDD = ""+DateUtil.getDay(implDate);
			implStartDD = (implStartDD.length() > 1) ? implStartDD : "0" + implStartDD;
			implStartYY = ""+DateUtil.getYear(implDate);
		}
		
		if(!"".equals(codeID1) && !"".equals(codeID2))
		{
			selectedFundOrFeat = codeID1+"#"+codeID2;
		}
		if(fromBack.equals("back"))
		{
			if(!"".equals(codeID1) && !"".equals(codeID2) && brokerRestrictionSelect.equals("Fund"))
			{	
				fundFlag = true;
				backList =  product.getCurrentRestrictionList(codeID1, codeID2, brokerRestrictionSelect, "back", "","");
	
			}
			if(!"".equals(codeID1) && !"".equals(codeID2) && brokerRestrictionSelect.equals("Feature") && (productNameFeat != null && !"".equals(productNameFeat)))
			{
				featFlag = true;
				backList =  product.getCurrentRestrictionList(codeID1, codeID2, brokerRestrictionSelect, "back", productNameFeat,"");
			}
		}
	
	if(fromBack.equals("rework"))
	{	
		if(prevSubmittedDt.contains("_"))
			prevSubmittedDt.replace("_", " ");
		if(!"".equals(codeID1) && !"".equals(codeID2) && brokerRestrictionSelect.equals("Fund"))
		{	
			fundFlag = true;
			backList =  product.getCurrentRestrictionList(codeID1, codeID2, brokerRestrictionSelect, "rework", "",prevSubmittedDt);
		}
		if(!"".equals(codeID1) && !"".equals(codeID2) && brokerRestrictionSelect.equals("Feature") && (productNameFeat != null && !"".equals(productNameFeat)))
		{
			featFlag = true;
			backList =  product.getCurrentRestrictionList(codeID1, codeID2, brokerRestrictionSelect, "rework", productNameFeat, prevSubmittedDt);
		}
	}
	if(backList != null)
	{
	    List<BrokerRestriction> addList = new ArrayList<BrokerRestriction>();
	    currentRestrictionList  = new ArrayList<BrokerRestriction>();
	for(int i=0; i<backList.size();i++)
	{	
		BrokerRestriction bri = backList.get(i);
		if(fromBack.equals("rework"))
		{	
			productFamily = bri.productType.trim().equals("0")?"Index":"Variable";
			productFamily1= bri.productFamily.trim();
			String prevImplMM = ""+DateUtil.getMonth(bri.prevImplDate);
			prevImplMM = (prevImplMM.length() > 1) ? prevImplMM : "0" + prevImplMM;
			String prevImplDD = ""+DateUtil.getDay(bri.prevImplDate);
			prevImplDD  = (prevImplDD .length() > 1) ? prevImplDD  : "0" + prevImplDD ;
			String prevImplYY = ""+DateUtil.getYear(bri.prevImplDate);
			prevImplDt = prevImplYY + "" + prevImplMM + "" + prevImplDD;
			prevsubBy     = bri.prevSubBy;	
		}
		if(BrokerRestriction.BR_RESTRICTION_ADD.equals(bri.action))
		{
			addList.add(bri);
		}
		else
		{
			if(BrokerRestriction.BR_RESTRICTION_UPDATE.equals(bri.action) || BrokerRestriction.BR_RESTRICTION_DELETE.equals(bri.action) || "E".equals(bri.action))
			{	
				currentRestrictionList.add(bri);
			}	
		}
	}
	List<BrokerRestriction> generalAddList = new ArrayList<BrokerRestriction>();
	List<BrokerRestriction> expAddList = new ArrayList<BrokerRestriction>();
	for(int z=0; z<addList.size();z++)
	{
		BrokerRestriction br = addList.get(z);
		if("-999".equals(br.brID))
		{	
			generalAddList.add(br);
		}
		if(!"-999".equals(br.brID))
		{	
			expAddList.add(br);
		}   	
	}
			HashSet<String> productSet = new HashSet<String>();
			HashSet<String> toBrokerhSet = new HashSet<String>();			
			brRestGenStartmM  = new String[generalAddList.size()];
			brRestGenStartdD = new String[generalAddList.size()];
			brRestGenStartyY = new String[generalAddList.size()];
			brRestGenEndmM = new String[generalAddList.size()];
			brRestGenEnddD = new String[generalAddList.size()];
			brRestGenEndyY = new String[generalAddList.size()];
			genAddRest = new String[generalAddList.size()];
			generalProductSelect = new String[generalAddList.size()];
			
		    for(int k=0; k<generalAddList.size(); k++)
		    {
		    	BrokerRestriction bri = generalAddList.get(k);
		    	productSet.add(bri.planCode);
		    	toBrokerhSet.add(bri.brID);
		
				String strDate = bri.rateStartdate;
				
				brRestGenStartmM[k] = ""+DateUtil.getMonth(strDate);
				brRestGenStartmM [k]= (brRestGenStartmM[k].length() > 1) ? brRestGenStartmM[k] : "0" + brRestGenStartmM[k];
				brRestGenStartdD[k] = ""+DateUtil.getDay(strDate);
				brRestGenStartdD[k]  = (brRestGenStartdD[k] .length() > 1) ? brRestGenStartdD[k]  : "0" + brRestGenStartdD[k] ;
				brRestGenStartyY[k] = ""+DateUtil.getYear(strDate);
				String endDate = bri.rateEnddate;
				
				brRestGenEndmM[k] = ""+DateUtil.getMonth(endDate);
				brRestGenEndmM[k] = (brRestGenEndmM[k].length() > 1) ? brRestGenEndmM[k] : "0" + brRestGenEndmM[k];
				brRestGenEnddD[k] = ""+DateUtil.getDay(endDate);
				brRestGenEnddD[k]  = (brRestGenEnddD[k] .length() > 1) ? brRestGenEnddD[k]  : "0" + brRestGenEnddD[k] ;
				brRestGenEndyY[k] = ""+DateUtil.getYear(endDate);
			
				genAddRest[k] = bri.restrictionStatus;
						
				generalProductSelect[k] =bri.planCode;
		    	
		    }	
					bRStartExpmM = new String[expAddList.size()];
					bRStartExpdD = new String[expAddList.size()];
					bRStartExpyY = new String[expAddList.size()];
					bREndExpmM = new String[expAddList.size()];
					bREndExpdD = new String[expAddList.size()];
					bREndExpyY = new String[expAddList.size()];
					expBDSelect = new String[expAddList.size()];
					expRestriction = new String[expAddList.size()];
		    		expProductSelect = new String[expAddList.size()];
		    		
		    for(int l=0; l<expAddList.size(); l++)
		    {
		    	BrokerRestriction brAdd = expAddList.get(l);
		    	productSet.add(brAdd.planCode);
		    	toBrokerhSet.add(brAdd.brID);
				String strDate = brAdd.rateStartdate;
				bRStartExpmM[l] = ""+DateUtil.getMonth(strDate);
				bRStartExpmM[l] = (bRStartExpmM[l].length() > 1) ? bRStartExpmM[l] : "0" + bRStartExpmM[l];
				bRStartExpdD[l] = ""+DateUtil.getDay(strDate);
				bRStartExpdD[l]  = (bRStartExpdD[l] .length() > 1) ? bRStartExpdD[l]  : "0" + bRStartExpdD[l] ;
				bRStartExpyY[l] = ""+DateUtil.getYear(strDate);
				
				String endDate = brAdd.rateEnddate;
				bREndExpmM[l] = ""+DateUtil.getMonth(endDate);
				bREndExpmM[l] = (bREndExpmM[l].length() > 1) ? bREndExpmM[l] : "0" + bREndExpmM[l];
				bREndExpdD[l] = ""+DateUtil.getDay(endDate);
				bREndExpdD[l]  = (bREndExpdD[l] .length() > 1) ? bREndExpdD[l]  : "0" + bREndExpdD[l];
				bREndExpyY[l] = ""+DateUtil.getYear(endDate);
		
				expRestriction[l] = brAdd.restrictionStatus;
				expBDSelect[l] = brAdd.brID;
				expProductSelect[l] = brAdd.planCode;
		    } 
		selectedProductName = new String[productSet.size()];
		int pi = 0;
		for (String prod : productSet) 
		{
			selectedProductName[pi] = prod;
			pi++;
		}
	int pr = 0;
	selectedToBdList = new String[toBrokerhSet.size()];
	for (String broker : toBrokerhSet) 
	{
		selectedToBdList[pr] = broker.trim();
		pr++;
	}
 }	
}//Back and Rework END
if(!"0".equals(productFamily) )
{	
	if(productFamily.equals("Variable"))
		plnCode = "1";
	if(productFamily.equals("Index"))
		plnCode = "0";
	if(brokerRestrictionSelect.equals("Feature"))
		productPlanList = (java.util.ArrayList<BrokerRestriction>)product.getFundOrFeatureRestrictions(brokerRestrictionSelect, codeID1, codeID2, "PRODUCT", plnCode);
	else
		productFamilyMap = (java.util.TreeMap<Integer, String>)product.getProductFamily(Integer.parseInt(plnCode));
}
if(productNameFeat != null || selectedProductName !=null )
{
	if(brokerRestrictionSelect.equals("Feature") && productNameFeat != null)
	{	
		String prod[] = new String[1];
		prod[0] = productNameFeat;
		brFundorFeatList = product.getFundOrFeatureRestrictions(brokerRestrictionSelect, null, null, null, productNameFeat);
		brokerDealerMap = product.getBrokerDelaerList(prod);	
	}
}
if(selectedFundOrFeat != null && !"0".equals(selectedFundOrFeat) && !"".equals(selectedFundOrFeat))
{
	codeID1=selectedFundOrFeat.substring(0,selectedFundOrFeat.indexOf("#"));
	codeID2 = selectedFundOrFeat.substring(selectedFundOrFeat.lastIndexOf("#")+1);		
}
if (brokerRestrictionSelect.equals("Fund") && productFamily != null && !productFamily.equals("0") && !productFamily1.equals(""))
{
	brFundorFeatList = product.getFundOrFeatureRestrictions(brokerRestrictionSelect, null, null, null, productFamily1);	
}
if(!("".equals(codeID1) && "".equals(codeID2)) && brokerRestrictionSelect.equals("Fund") && productFamily != null && !productFamily.equals("0") && !productFamily1.equals(""))
{	
	productPlanList = (java.util.ArrayList<BrokerRestriction>)product.getFundOrFeatureRestrictions(brokerRestrictionSelect, codeID1, codeID2, "PRODUCT", plnCode);
	if(brokerRestrictionSelect.equals(searchBrokerRest) && productFamily.equals(searchProdFamly) && productFamily1.equals(searchProdFamly1) && selectedFundOrFeat.equals(SearchfundOrFeature))
		fundFlag = true;
	if((currentRestrictionList == null || currentRestrictionList.size() == 0))
		currentRestrictionList =  product.getCurrentRestrictionList(codeID1, codeID2, brokerRestrictionSelect, "",  "","");
}
if("rework".equals(fromBack))
{
	fundFlag=true;	
}
if(!("".equals(codeID1) && "".equals(codeID2)) && brokerRestrictionSelect.equals("Fund") && productFamily != null && !productFamily.equals("0") && !productFamily.equals("") && fundFlag)
{
	boolean allPrdFlg = false;
	for(int i=0;selectedProductName != null && i<selectedProductName.length;i++)
	{	
		if("$$$".equals(selectedProductName[i]))
			allPrdFlg = true;
	}
	if(allPrdFlg && productPlanList != null)
	{
		
		String skipAllProducts[] = new String[productPlanList.size()]; 
		for(int k=0; k<productPlanList.size(); k++)
		{
			BrokerRestriction br = productPlanList.get(k);
			skipAllProducts[k] = br.planCode;
		}
		brokerDealerMap = product.getBrokerDelaerList(skipAllProducts);

	}else
		brokerDealerMap = product.getBrokerDelaerList(selectedProductName);
}

if((brokerRestrictionSelect.equals("Feature")) && !("".equals(codeID1) && "".equals(codeID2)) && productNameFeat !=null)
{
	brFundorFeatList = (java.util.ArrayList<BrokerRestriction>)product.getFundOrFeatureRestrictions(brokerRestrictionSelect, codeID1, codeID2, null, productNameFeat);
	if((currentRestrictionList == null || currentRestrictionList.size() == 0))
		currentRestrictionList =  product.getCurrentRestrictionList(codeID1, codeID2, brokerRestrictionSelect, "", productNameFeat,"");
	if(fromBack.equals("back") ||fromBack.equals("rework"))
	{
		featFlag = true;
		String prod[] = new String[1];
		prod[0] = productNameFeat;
		brokerDealerMap = product.getBrokerDelaerList(prod);
	}
}

if(genAddRest != null || expRestriction != null && !(fromBack.equals("back") ||fromBack.equals("rework")))
{
	Enumeration<String> items = request.getParameterNames();
	
	if(genAddRest != null )
		sortOrderGen = new ArrayList<String>();
	if(expRestriction != null)
		sortOrderExp = new ArrayList<String>();
	
	int i=0;
	int j=0;
	while(items.hasMoreElements())
	{
	  	String name = items.nextElement();
	  	if(name.startsWith("brRestGenStartMM"))
		{	
	  		sortOrderGen.add(name.substring(name.lastIndexOf("M")+1,name.length()));
	  		i++;
		}
	  	if(name.startsWith("bRStartExpDD"))
		{	
	  		sortOrderExp.add(name.substring(name.lastIndexOf("D")+1,name.length()));
	  		j++;
		}
	}
	if(sortOrderGen != null && sortOrderGen.size() > 0)
		Collections.sort(sortOrderGen);
	if(sortOrderExp != null && sortOrderExp.size() > 0)
		Collections.sort(sortOrderExp);
}

if((brokerRestrictionSelect.equals("Fund")) && !fromBack.equals("back") && !fromBack.equals("rework"))
{
	if(currentGenBDID != null )
	{	
		currentGenProduct = new String[currentGenBDID.length];
		bRCurrntStartMM = new String[currentGenBDID.length];
		
		bRCurrntStartDD = new String[currentGenBDID.length];
		bRCurrntStartYY = new String[currentGenBDID.length];
		cStartDtGen = new String[currentGenBDID.length]; 
		cEditGen = new String[currentGenBDID.length];
		cDeleteGen = new String[currentGenBDID.length];
		bRCurrntEndMM = new String[currentGenBDID.length];
		bRCurrntEndDD =  new String[currentGenBDID.length];
		bRCurrntEndYY =  new String[currentGenBDID.length];
		cEndDtGen = new String[currentGenBDID.length];
		slCurrntGenrestrict  = new String[currentGenBDID.length];

	for(int i=0; i<currentGenBDID.length;i++)
	{
		
		cEditGen[i] = request.getParameter("selectAllEditGen"+i)== null?"":request.getParameter("selectAllEditGen"+i);
		cDeleteGen[i]= request.getParameter("selectAllDeleteGen"+i)== null?"":request.getParameter("selectAllDeleteGen"+i);
		
			if(cEditGen[i].equals("1") || cDeleteGen[i].equals("1"))
			{	
				bRCurrntStartMM[i]=request.getParameter("bRCurrntStartMM"+i);		
				bRCurrntStartDD[i]=request.getParameter("bRCurrntStartDD"+i);		
				bRCurrntStartYY[i]=request.getParameter("bRCurrntStartYY"+i);
				String brRestExpStMM = (bRCurrntStartMM[i].length() > 1) ? bRCurrntStartMM[i] : "0" + bRCurrntStartMM[i];		
				String brRestExpStDD = (bRCurrntStartDD[i].length() > 1) ? bRCurrntStartDD[i] : "0" + bRCurrntStartDD[i];
				cStartDtGen[i] = bRCurrntStartYY[i] + brRestExpStMM + brRestExpStDD;
				if(cDeleteGen[i].equals("1"))
				{
					bRCurrntEndMM[i]=request.getParameter("bRCurrntEndMMD"+i);
					bRCurrntEndDD[i]=request.getParameter("bRCurrntEndDDD"+i);
					bRCurrntEndYY[i]=request.getParameter("bRCurrntEndYYD"+i);
					slCurrntGenrestrict[i] = request.getParameter("currntGenRestD"+i);
				}else
				{	
					bRCurrntEndMM[i]=request.getParameter("bRCurrntEndMM"+i);
					bRCurrntEndDD[i]=request.getParameter("bRCurrntEndDD"+i);
					bRCurrntEndYY[i]=request.getParameter("bRCurrntEndYY"+i);
					slCurrntGenrestrict[i] = request.getParameter("currntGenrestrict"+i);
				}
				String brRestExpEndMM = (bRCurrntEndMM[i].length() > 1) ? bRCurrntEndMM[i] : "0" + bRCurrntEndMM[i];
				String brRestExpEndDD = (bRCurrntEndDD[i].length() > 1) ? bRCurrntEndDD[i] : "0" + bRCurrntEndDD[i];
				cEndDtGen[i] =  bRCurrntEndYY[i] + brRestExpEndMM + brRestExpEndDD;
				slCurrntGenrestrict[i] = request.getParameter("currntGenrestrict"+i);
				currentGenProduct[i] =  request.getParameter("currentGenProduct"+i);
				
			}
		}
}

	if (currentExpBDID != null) 
	{	
		currentExpProduct = new String[currentExpBDID.length];
		currentExpBDID = new String[currentExpBDID.length];
	
		bRCurrntStartExpMM = new String[currentExpBDID.length];
		bRCurrntStartExpDD = new String[currentExpBDID.length];
		bRCurrntStartExpYY = new String[currentExpBDID.length];
		cStartDtExp = new String[currentExpBDID.length];
	
		bRCurrntEndExpMM = new String[currentExpBDID.length];
		bRCurrntEndExpDD = new String[currentExpBDID.length];
		bRCurrntEndExpYY = new String[currentExpBDID.length];
		cEndDtExp = new String[currentExpBDID.length];
		cEditExp = new String[currentExpBDID.length];
		cDeleteExp = new String[currentExpBDID.length];
		slCurrentRestrictExp = new String[currentExpBDID.length];
		currentExpBD = new String[currentExpBDID.length];
	
		for (int i = 0; i < currentExpBDID.length; i++) 
		{		
			cEditExp[i] = request.getParameter("selectAllEditExp" + i) == null ? "": request.getParameter("selectAllEditExp" + i);
			cDeleteExp[i] = request.getParameter("selectAllDeleteExp" + i) == null ? "": request.getParameter("selectAllDeleteExp" + i);
			
			if (cEditExp[i].equals("1") || cDeleteExp[i].equals("1")) 
			{		
				bRCurrntStartExpMM[i] = request.getParameter("bRCurrntStartExpMM" + i);
				bRCurrntStartExpDD[i] = request.getParameter("bRCurrntStartExpDD" + i);
				bRCurrntStartExpYY[i] = request.getParameter("bRCurrntStartExpYY" + i);
				slCurrentRestrictExp[i] = request.getParameter("currentExcRestrict" + i);
	
				String brRestExpStMM = (bRCurrntStartExpMM[i].length() > 1) ? bRCurrntStartExpMM[i]: "0" + bRCurrntStartExpMM[i];
				String brRestExpStDD = (bRCurrntStartExpDD[i].length() > 1) ? bRCurrntStartExpDD[i]: "0" + bRCurrntStartExpDD[i];
	
				cStartDtExp[i] = bRCurrntStartExpYY[i] + brRestExpStMM + brRestExpStDD;			
				if(cDeleteExp[i].equals("1"))
				{
					bRCurrntEndExpMM[i] = request.getParameter("bRCurrntEndExpMMD" + i);
					bRCurrntEndExpDD[i] = request.getParameter("bRCurrntEndExpDDD" + i);
					bRCurrntEndExpYY[i] = request.getParameter("bRCurrntEndExpYYD" + i);
					slCurrentRestrictExp[i] = request.getParameter("currentExcRestrictD" + i);
				}
				else
				{
					bRCurrntEndExpMM[i] = request.getParameter("bRCurrntEndExpMM" + i);
					bRCurrntEndExpDD[i] = request.getParameter("bRCurrntEndExpDD" + i);
					bRCurrntEndExpYY[i] = request.getParameter("bRCurrntEndExpYY" + i);
					slCurrentRestrictExp[i] = request.getParameter("currentExcRestrict" + i);
				}
	
				String brRestExpEndMM = (bRCurrntEndExpMM[i].length() > 1) ? bRCurrntEndExpMM[i]: "0" + bRCurrntEndExpMM[i];
				String brRestExpEndDD = (bRCurrntEndExpDD[i].length() > 1) ? bRCurrntEndExpDD[i]: "0" + bRCurrntEndExpDD[i];
				
				currentExpBD[i] = request.getParameter("currentExpBD" + i);
				cEndDtExp[i] = bRCurrntEndExpYY[i] + brRestExpEndMM + brRestExpEndDD;
	
				currentExpProduct[i] = request.getParameter("currentExpProduct" + i);
			}
		}
	}	
//Add gen
	if (genAddRest != null) 
	{

		brRestGenStartmM = new String[genAddRest.length];
		brRestGenStartdD = new String[genAddRest.length];
		brRestGenStartyY = new String[genAddRest.length];
		brRestGenStartDate = new String[genAddRest.length];
	
		brRestGenEndmM = new String[genAddRest.length];
		brRestGenEnddD = new String[genAddRest.length];
		brRestGenEndyY = new String[genAddRest.length];
		brRestGenEndDate = new String[genAddRest.length];
		String id = "";
		for (int i = 0; i < genAddRest.length; i++) 
		{
			id = sortOrderGen.get(i);
			brRestGenStartmM[i] = request.getParameter("brRestGenStartMM" + id);
			brRestGenStartdD[i] = request.getParameter("brRestGenStartDD" + id);
			brRestGenStartyY[i] = request.getParameter("brRestGenStartYY" + id);
			
			if(null != brRestGenStartmM[i] && null != brRestGenStartdD[i] && null != brRestGenStartyY[i])
			{
				String brRestGenStartMM = (brRestGenStartmM[i].length() > 1) ? brRestGenStartmM[i]: "0" + brRestGenStartmM[i];
				String brRestGenStartDD = (brRestGenStartdD[i].length() > 1) ? brRestGenStartdD[i]: "0" + brRestGenStartdD[i];
				brRestGenStartDate[i] = brRestGenStartyY[i] + brRestGenStartMM + brRestGenStartDD;
			}
			brRestGenEndmM[i] = request.getParameter("brRestGenEndMM" + id);
			brRestGenEnddD[i] = request.getParameter("brRestGenEndDD" + id);
			brRestGenEndyY[i] = request.getParameter("brRestGenEndYY" + id);
			
			if(null != brRestGenEndmM[i] && null != brRestGenEnddD[i] && null != brRestGenEndyY[i])
			{
				String brRestGenEndMM = (brRestGenEndmM[i].length() > 1) ? brRestGenEndmM[i]: "0" + brRestGenEndmM[i];
				String brRestGenEndDD = (brRestGenEnddD[i].length() > 1) ? brRestGenEnddD[i]: "0" + brRestGenEnddD[i];
	
				brRestGenEndDate[i] = brRestGenEndyY[i] + brRestGenEndMM + brRestGenEndDD;
			}
		}
	}
//Add Excep restriction
	if (expRestriction != null) 
	{
		bRStartExpmM = new String[expRestriction.length];
		bRStartExpdD = new String[expRestriction.length];
		bRStartExpyY = new String[expRestriction.length];
		brStartExpDate = new String[expRestriction.length];
	
		bREndExpmM = new String[expRestriction.length];
		bREndExpdD = new String[expRestriction.length];
		bREndExpyY = new String[expRestriction.length];
		brEndExpDate = new String[expRestriction.length];
		String id = "";
		for (int i = 0; i < expRestriction.length; i++) 
		{
			id = sortOrderExp.get(i);
			bRStartExpmM[i] = request.getParameter("bRStartExpMM" + id);
			bRStartExpdD[i] = request.getParameter("bRStartExpDD" + id);
			bRStartExpyY[i] = request.getParameter("bRStartExpYY" + id);
			
			if(null != bRStartExpmM[i] && null != bRStartExpdD[i] && null != bRStartExpyY[i])
			{
				String brRestExpStMM = (bRStartExpmM[i].length() > 1) ? bRStartExpmM[i]: "0" + bRStartExpmM[i];
				String brRestExpStDD = (bRStartExpdD[i].length() > 1) ? bRStartExpdD[i]: "0" + bRStartExpdD[i];
	
				brStartExpDate[i] = bRStartExpyY[i] + brRestExpStMM + brRestExpStDD;
			}
			
			bREndExpmM[i] = request.getParameter("bREndExpMM" + id);
			bREndExpdD[i] = request.getParameter("bREndExpDD" + id);
			bREndExpyY[i] = request.getParameter("bREndExpYY" + id);
			
			if(null != bREndExpmM[i] && null != bREndExpdD[i] && null != bREndExpyY[i])
			{
				String brRestExpEndMM = (bRStartExpmM[i].length() > 1) ? bRStartExpmM[i]: "0" + bRStartExpmM[i];
				String brRestExpEndDD = (bRStartExpdD[i].length() > 1) ? bRStartExpdD[i]: "0" + bRStartExpdD[i];
				brEndExpDate[i] = bREndExpyY[i] + brRestExpEndMM + brRestExpEndDD;
			}
		}
	
	}
}
//Post Method starts here.

if (request.getMethod().equalsIgnoreCase("post"))
{	
	
	if(  (request.getParameter("search.x") != null ))
	{	
		if("0".equals(productFamily))
		{
			errorMessage += "Product Family must be selected.<br>"; 	
		}
		if(!("".equals(codeID1) && "".equals(codeID2)) && brokerRestrictionSelect.equals("Fund"))
		{
			fundFlag = true;
			productPlanList = (java.util.ArrayList<BrokerRestriction>)product.getFundOrFeatureRestrictions(brokerRestrictionSelect, codeID1, codeID2, "PRODUCT", plnCode);
			currentRestrictionList =  product.getCurrentRestrictionList(codeID1, codeID2, brokerRestrictionSelect, "", "","");
		}
		else if(("".equals(codeID1) && "".equals(codeID2)))
		{
			errorMessage += brokerRestrictionSelect+" must be selected.<br>";
		}
		if((brokerRestrictionSelect.equals("Feature")) && !("".equals(codeID1) && "".equals(codeID2)) && productNameFeat !=null)
		{
	
			featFlag = true;
			fundFlag = true;
			brFundorFeatList = (java.util.ArrayList<BrokerRestriction>)product.getFundOrFeatureRestrictions(brokerRestrictionSelect, codeID1, codeID2, null, productNameFeat);
	
			currentRestrictionList =  product.getCurrentRestrictionList(codeID1, codeID2, brokerRestrictionSelect, "",productNameFeat,"");
		}
	}
	if (request.getParameter("Next.x") != null )
	{
		featFlag = true;
		 if(! DateUtil.isDateValid( strImplDate ) )
		         errorMessage += "System Effective Date provided is invalid.<br>";  
		 else
		 {
		   if(DateUtil.CompareDate(DateUtil.addDays(new Date(), 1),DateUtil.toDate( strImplDate )))
		   {
		      errorMessage += "System Effective Date should be greater than System Date.<br>"; 
		   }
		 }
		if(currentGenBDID != null)
		{		
			currentGenProduct = new String[currentGenBDID.length];
			bRCurrntStartMM = new String[currentGenBDID.length];
			bRCurrntStartDD = new String[currentGenBDID.length];
			bRCurrntStartYY = new String[currentGenBDID.length];
			cStartDtGen = new String[currentGenBDID.length]; 
			cEditGen = new String[currentGenBDID.length];
			cDeleteGen = new String[currentGenBDID.length];
			bRCurrntEndMM = new String[currentGenBDID.length];
			bRCurrntEndDD =  new String[currentGenBDID.length];
			bRCurrntEndYY =  new String[currentGenBDID.length];
			cEndDtGen = new String[currentGenBDID.length];
			slCurrntGenrestrict  = new String[currentGenBDID.length];

			for(int i=0; i<currentGenBDID.length;i++)
			{
			
				cEditGen[i] = request.getParameter("selectAllEditGen"+i)== null?"":request.getParameter("selectAllEditGen"+i);
				cDeleteGen[i]= request.getParameter("selectAllDeleteGen"+i)== null?"":request.getParameter("selectAllDeleteGen"+i);
			
				if(cEditGen[i].equals("1") || cDeleteGen[i].equals("1"))
				{
					
					bRCurrntStartMM[i]=request.getParameter("bRCurrntStartMM"+i);		
					bRCurrntStartDD[i]=request.getParameter("bRCurrntStartDD"+i);		
					bRCurrntStartYY[i]=request.getParameter("bRCurrntStartYY"+i);
					
					String brRestExpStMM = (bRCurrntStartMM[i].length() > 1) ? bRCurrntStartMM[i] : "0" + bRCurrntStartMM[i];		
					String brRestExpStDD = (bRCurrntStartDD[i].length() > 1) ? bRCurrntStartDD[i] : "0" + bRCurrntStartDD[i];		
					
					cStartDtGen[i] = bRCurrntStartYY[i] + brRestExpStMM + brRestExpStDD;
					if(cDeleteGen[i].equals("1"))
					{
						bRCurrntEndMM[i]=request.getParameter("bRCurrntEndMMD"+i);
						bRCurrntEndDD[i]=request.getParameter("bRCurrntEndDDD"+i);
						bRCurrntEndYY[i]=request.getParameter("bRCurrntEndYYD"+i);
						slCurrntGenrestrict[i] = request.getParameter("currntGenRestD"+i);
					}else
					{
						
						bRCurrntEndMM[i]=request.getParameter("bRCurrntEndMM"+i);
						bRCurrntEndDD[i]=request.getParameter("bRCurrntEndDD"+i);
						bRCurrntEndYY[i]=request.getParameter("bRCurrntEndYY"+i);
						slCurrntGenrestrict[i] = request.getParameter("currntGenrestrict"+i);
					}
					String brRestExpEndMM = (bRCurrntEndMM[i].length() > 1) ? bRCurrntEndMM[i] : "0" + bRCurrntEndMM[i];
					String brRestExpEndDD = (bRCurrntEndDD[i].length() > 1) ? bRCurrntEndDD[i] : "0" + bRCurrntEndDD[i];
					cEndDtGen[i] =  bRCurrntEndYY[i] + brRestExpEndMM + brRestExpEndDD;
					currentGenProduct[i] =  request.getParameter("currentGenProduct"+i);
					
				BrokerRestriction br = new BrokerRestriction();
				if(br.equals(BrokerRestriction.BR_RESTRICTION_FEAT))
					br.code = Integer.parseInt(codeID1);
				else
					br.accountCode = codeID1;
				br.divisionCode = codeID2;
				br.brEffectiveDate = cStartDtGen[i];
				br.brEndDate = cEndDtGen[i];
				br.restrictionStatus = slCurrntGenrestrict[i];
				String pln = (currentGenProduct[i].length() == 2) ? "0" + currentGenProduct[i] : currentGenProduct[i];
				br.planCode = 	pln;	
				String bdID = currentGenBDID[i];
				br.brokerID = bdID;
				br.requesterID = loginUser;
				br.implDate = strImplDate;
				br.action = (cEditGen[i].equals("1")) ? BrokerRestriction.BR_RESTRICTION_UPDATE : BrokerRestriction.BR_RESTRICTION_DELETE;
				br.reqStatus = BrokerRestriction.BR_RESTRICTION_VERIFY;
				br.submittedDate = submittedDate;
				br.state = "Apply";
				if(prevSubmittedDt.contains("_"))
					replacePrevSubDt = prevSubmittedDt.replace("_", " ");
				br.prevSubmittedDate = replacePrevSubDt;
				
						totalList.add(br);
					}
			}
			for( int i=0;i<cStartDtGen.length;i++)
		 	{ 
				if(cEditGen[i].equals("1") || cDeleteGen[i].equals("1"))
				{
				 	if( DateUtil.isDateValid( cStartDtGen[i] ) )
						genStartDate = DateUtil.toDate ( cStartDtGen[i] );
					if( DateUtil.isDateValid( cEndDtGen[i] ) )
						genEndDate = DateUtil.toDate ( cEndDtGen[i] );
					else
					{
						errorMessage += "End date is invalid.<br>";
						break;
					}
					if( genStartDate != null && genEndDate != null)
					{
						if(genEndDate.before(genStartDate) )
						{
						errorMessage += "Start date cannot be greater than end date.<br>";
						break;
						}
					}
				}
		 	}
		}
		if (currentExpBDID != null) 
		{
				
				currentExpProduct = new String[currentExpBDID.length];
				currentExpBDID = new String[currentExpBDID.length];

				bRCurrntStartExpMM = new String[currentExpBDID.length];
				bRCurrntStartExpDD = new String[currentExpBDID.length];
				bRCurrntStartExpYY = new String[currentExpBDID.length];
				cStartDtExp = new String[currentExpBDID.length];

				bRCurrntEndExpMM = new String[currentExpBDID.length];
				bRCurrntEndExpDD = new String[currentExpBDID.length];
				bRCurrntEndExpYY = new String[currentExpBDID.length];
				cEndDtExp = new String[currentExpBDID.length];
				cEditExp = new String[currentExpBDID.length];
				cDeleteExp = new String[currentExpBDID.length];
				slCurrentRestrictExp = new String[currentExpBDID.length];
				currentExpBD = new String[currentExpBDID.length];
				

				for (int i = 0; i < currentExpBDID.length; i++) {
					
					cEditExp[i] = request.getParameter("selectAllEditExp" + i) == null ? "": request.getParameter("selectAllEditExp" + i);
					cDeleteExp[i] = request.getParameter("selectAllDeleteExp" + i) == null ? "": request.getParameter("selectAllDeleteExp" + i);
					
					if (cEditExp[i].equals("1") || cDeleteExp[i].equals("1")) 
					{						
						
						bRCurrntStartExpMM[i] = request.getParameter("bRCurrntStartExpMM" + i);
						bRCurrntStartExpDD[i] = request.getParameter("bRCurrntStartExpDD" + i);
						bRCurrntStartExpYY[i] = request.getParameter("bRCurrntStartExpYY" + i);
						

						String brRestExpStMM = (bRCurrntStartExpMM[i].length() > 1) ? bRCurrntStartExpMM[i]
								: "0" + bRCurrntStartExpMM[i];
						String brRestExpStDD = (bRCurrntStartExpDD[i].length() > 1) ? bRCurrntStartExpDD[i]
								: "0" + bRCurrntStartExpDD[i];
						cStartDtExp[i] = bRCurrntStartExpYY[i] + brRestExpStMM + brRestExpStDD;
						if(cDeleteExp[i].equals("1"))
						{
							bRCurrntEndExpMM[i] = request.getParameter("bRCurrntEndExpMMD" + i);
							bRCurrntEndExpDD[i] = request.getParameter("bRCurrntEndExpDDD" + i);
							bRCurrntEndExpYY[i] = request.getParameter("bRCurrntEndExpYYD" + i);
							slCurrentRestrictExp[i] = request.getParameter("currentExcRestrictD" + i);
						}
						else
						{
							bRCurrntEndExpMM[i] = request.getParameter("bRCurrntEndExpMM" + i);
							bRCurrntEndExpDD[i] = request.getParameter("bRCurrntEndExpDD" + i);
							bRCurrntEndExpYY[i] = request.getParameter("bRCurrntEndExpYY" + i);
							slCurrentRestrictExp[i] = request.getParameter("currentExcRestrict" + i);
						}
						String brRestExpEndMM = (bRCurrntEndExpMM[i].length() > 1) ? bRCurrntEndExpMM[i]:"0" + bRCurrntEndExpMM[i];
						String brRestExpEndDD = (bRCurrntEndExpDD[i].length() > 1) ? bRCurrntEndExpDD[i]:"0" + bRCurrntEndExpDD[i];
						currentExpBD[i] = request.getParameter("currentExpBD" + i);
						cEndDtExp[i] = bRCurrntEndExpYY[i] + brRestExpEndMM + brRestExpEndDD;
						currentExpProduct[i] = request.getParameter("currentExpProduct" + i);
						BrokerRestriction br = new BrokerRestriction();
						if (br.equals(BrokerRestriction.BR_RESTRICTION_FEAT))
							br.code = Integer.parseInt(codeID1);
						else
							br.accountCode = codeID1;
						br.divisionCode = codeID2;
						br.brEffectiveDate = cStartDtExp[i];
						br.brEndDate = cEndDtExp[i];
						br.restrictionStatus = slCurrentRestrictExp[i];
						String plancd = (currentExpProduct[i].length() == 2) ? "0" + currentExpProduct[i]: currentExpProduct[i];
						br.planCode = plancd;
						br.brokerID = currentExpBD[i];
						br.requesterID = loginUser;
						br.implDate = strImplDate;
						br.action = (cEditExp[i].equals("1")) ? BrokerRestriction.BR_RESTRICTION_UPDATE
								: BrokerRestriction.BR_RESTRICTION_DELETE;
						br.reqStatus = BrokerRestriction.BR_RESTRICTION_VERIFY;
						br.submittedDate = submittedDate;
						br.state = "Apply";
						if(prevSubmittedDt.contains("_"))
							replacePrevSubDt = prevSubmittedDt.replace("_", " ");
						br.prevSubmittedDate = replacePrevSubDt;
						
						totalList.add(br);
					}
				}
				for( int i=0;i<cEndDtExp.length;i++)
				{ 
				if (cEditExp[i].equals("1") || cDeleteExp[i].equals("1")) 
				{ 
					if( DateUtil.isDateValid( cStartDtExp[i] ) )
						genStartDate = DateUtil.toDate ( cStartDtExp[i] );
					if( DateUtil.isDateValid( cEndDtExp[i] ) )
						genEndDate = DateUtil.toDate ( cEndDtExp[i] );
					else
					{
						errorMessage += "End date is invalid.<br>";
						break;
					}
					if( genStartDate != null && genEndDate != null)
					{
						if(genEndDate.before(genStartDate) )
						{
							errorMessage += "Start date cannot be greater than end date.<br>";
							break;
						}
					}
				 }
			 }
		}	
			//Add gen
			if (genAddRest != null) 
			{
				brRestGenStartmM = new String[genAddRest.length];
				brRestGenStartdD = new String[genAddRest.length];
				brRestGenStartyY = new String[genAddRest.length];
				brRestGenStartDate = new String[genAddRest.length];

				brRestGenEndmM = new String[genAddRest.length];
				brRestGenEnddD = new String[genAddRest.length];
				brRestGenEndyY = new String[genAddRest.length];
				brRestGenEndDate = new String[genAddRest.length];
				String id = "";
				for (int i = 0; i < genAddRest.length; i++) 
				{
					id = sortOrderGen.get(i);
					brRestGenStartmM[i] = request.getParameter("brRestGenStartMM" + id);
					brRestGenStartdD[i] = request.getParameter("brRestGenStartDD" + id);
					brRestGenStartyY[i] = request.getParameter("brRestGenStartYY" + id);
					
					String brRestGenStartMM = (brRestGenStartmM[i].length() > 1) ? brRestGenStartmM[i]: "0" + brRestGenStartmM[i];
					String brRestGenStartDD = (brRestGenStartdD[i].length() > 1) ? brRestGenStartdD[i]: "0" + brRestGenStartdD[i];
					brRestGenStartDate[i] = brRestGenStartyY[i] + brRestGenStartMM + brRestGenStartDD;

					brRestGenEndmM[i] = request.getParameter("brRestGenEndMM" + id);
					brRestGenEnddD[i] = request.getParameter("brRestGenEndDD" + id);
					brRestGenEndyY[i] = request.getParameter("brRestGenEndYY" + id);

					String brRestGenEndMM = (brRestGenEndmM[i].length() > 1) ? brRestGenEndmM[i]: "0" + brRestGenEndmM[i];
					String brRestGenEndDD = (brRestGenEnddD[i].length() > 1) ? brRestGenEnddD[i]: "0" + brRestGenEnddD[i];

					brRestGenEndDate[i] = brRestGenEndyY[i] + brRestGenEndMM + brRestGenEndDD;

					BrokerRestriction brokerRestrictionAdd = new BrokerRestriction();

					if (brokerRestrictionSelect.equals(BrokerRestriction.BR_RESTRICTION_FEAT))
						brokerRestrictionAdd.accountCode = codeID1;
					else
						brokerRestrictionAdd.accountCode = codeID1;

					brokerRestrictionAdd.divisionCode = codeID2;
					brokerRestrictionAdd.brEffectiveDate = brRestGenStartDate[i];
					brokerRestrictionAdd.brEndDate = brRestGenEndDate[i];
					brokerRestrictionAdd.restrictionStatus = genAddRest[i];
					brokerRestrictionAdd.brokerID = defBrokerID;
					brokerRestrictionAdd.requesterID = loginUser;
					brokerRestrictionAdd.implDate = strImplDate;
					brokerRestrictionAdd.action = BrokerRestriction.BR_RESTRICTION_ADD;
					brokerRestrictionAdd.reqStatus = BrokerRestriction.BR_RESTRICTION_VERIFY;
					brokerRestrictionAdd.submittedDate = submittedDate;
					brokerRestrictionAdd.state = "Apply";
					if(prevSubmittedDt.contains("_"))
						replacePrevSubDt = prevSubmittedDt.replace("_", " ");
					brokerRestrictionAdd.prevSubmittedDate = replacePrevSubDt;
					brokerRestrictionAdd.planCode = (generalProductSelect[i].length() == 2)	? "0" + generalProductSelect[i] : generalProductSelect[i];
					
					totalList.add(brokerRestrictionAdd);
				
				}
				for(int k=0; k<generalProductSelect.length; k++)
				{
					if(generalProductSelect[k].equals(""))
					{
						errorMessage += "Product must be selected.<br/>";
						break;
					}
					for(int j=k+1; j<generalProductSelect.length; j++)
					{
						if(generalProductSelect[k].equals(generalProductSelect[j]))
						{
							if( DateUtil.isDateValid( brRestGenStartDate[j] ) &&  DateUtil.isDateValid( brRestGenEndDate[k] ))
							{
								genEndDate = DateUtil.toDate ( brRestGenEndDate[k] );
								genStartDate = DateUtil.toDate ( brRestGenStartDate[j] );
								if(!genStartDate.after(genEndDate))
									duplicateGen = true;
							}  
						}
					}
				}
				if(duplicateGen)
				{	
					errorMessage += "Duplicate -Records added for General Rule.<br>";
				}
				for( int i=0;i<brRestGenStartDate.length;i++)
				{	 
					if( DateUtil.isDateValid( brRestGenStartDate[i] ) )
						genStartDate = DateUtil.toDate ( brRestGenStartDate[i] );
					else
					{
					errorMessage += "Start date is invalid.";
					break;
					}

					if( DateUtil.isDateValid( brRestGenEndDate[i] ))
						genEndDate = DateUtil.toDate ( brRestGenEndDate[i] );
					else
					{
						errorMessage += "End date is invalid.<br>";
						break;
					}
					if( genStartDate != null && genEndDate != null)
					{
						if( genStartDate.after(genEndDate) )
						{
							errorMessage += "Start date cannot be greater than end date.<br>";
							break;
						}
					}
				 }
			}			
			//Add Excep restriction
			if (expRestriction != null) 
			{	
				bRStartExpmM = new String[expRestriction.length];
				bRStartExpdD = new String[expRestriction.length];
				bRStartExpyY = new String[expRestriction.length];
				brStartExpDate = new String[expRestriction.length];

				bREndExpmM = new String[expRestriction.length];
				bREndExpdD = new String[expRestriction.length];
				bREndExpyY = new String[expRestriction.length];
				brEndExpDate = new String[expRestriction.length];
				String id = "";
				for (int i = 0; i < expRestriction.length; i++) 
				{	
					id = sortOrderExp.get(i);
					bRStartExpmM[i] = request.getParameter("bRStartExpMM" + id);
					bRStartExpdD[i] = request.getParameter("bRStartExpDD" + id);
					bRStartExpyY[i] = request.getParameter("bRStartExpYY" + id);
					
					String brRestExpStMM = (bRStartExpmM[i].length() > 1) ? bRStartExpmM[i]
							: "0" + bRStartExpmM[i];
					String brRestExpStDD = (bRStartExpdD[i].length() > 1) ? bRStartExpdD[i]
							: "0" + bRStartExpdD[i];

					brStartExpDate[i] = bRStartExpyY[i] + brRestExpStMM + brRestExpStDD;
					
					bREndExpmM[i] = request.getParameter("bREndExpMM" + id);
					bREndExpdD[i] = request.getParameter("bREndExpDD" + id);
					bREndExpyY[i] = request.getParameter("bREndExpYY" + id);
					

					String brRestExpEndMM = (bREndExpmM[i].length() > 1) ? bREndExpmM[i]
							: "0" + bREndExpmM[i];
					String brRestExpEndDD = (bREndExpdD[i].length() > 1) ? bREndExpdD[i]
							: "0" + bREndExpdD[i];

					brEndExpDate[i] = bREndExpyY[i] + brRestExpEndMM + brRestExpEndDD;
					BrokerRestriction brokerRestrictionExp = new BrokerRestriction();
					

					if (brokerRestrictionSelect.equals(BrokerRestriction.BR_RESTRICTION_FEAT))
						brokerRestrictionExp.accountCode = "154";
					else
						brokerRestrictionExp.accountCode = codeID1;
					brokerRestrictionExp.divisionCode = codeID2;
					brokerRestrictionExp.brEffectiveDate = brStartExpDate[i];
					brokerRestrictionExp.brEndDate = brEndExpDate[i];
					brokerRestrictionExp.restrictionStatus = expRestriction[i];
					
					brokerRestrictionExp.brokerID = expBDSelect[i];
					
					brokerRestrictionExp.requesterID = loginUser;
					brokerRestrictionExp.implDate = strImplDate;
					brokerRestrictionExp.action = BrokerRestriction.BR_RESTRICTION_ADD;
					brokerRestrictionExp.reqStatus = BrokerRestriction.BR_RESTRICTION_VERIFY;
					brokerRestrictionExp.submittedDate = submittedDate;
					brokerRestrictionExp.state = "Apply";
					if(prevSubmittedDt.contains("_"))
						replacePrevSubDt = prevSubmittedDt.replace("_", " ");
					brokerRestrictionExp.prevSubmittedDate = replacePrevSubDt;
					
						brokerRestrictionExp.planCode = (expProductSelect[i].length() == 2)
								? "0" + expProductSelect[i] : expProductSelect[i];
						
						totalList.add(brokerRestrictionExp);
				}
				for(int k=0; k<expBDSelect.length; k++)
				{
					if(expBDSelect[k].equals("0"))
					{	
						errorMessage += "Please Select Broker Dealer in Add section.<br/>";
						break;
					}
					for(int j=k+1; j<expBDSelect.length; j++)
					{
						if(expBDSelect[k].equals(expBDSelect[j]))
						{
							if(expProductSelect[k].equals(expProductSelect[j]))  //SCR55766 START
							{	
								if( DateUtil.isDateValid( brStartExpDate[j] ) &&  DateUtil.isDateValid( brEndExpDate[k] ))
								{
									genEndDate = DateUtil.toDate ( brEndExpDate[k] );
									genStartDate = DateUtil.toDate ( brStartExpDate[j] );
									if(!genStartDate.after(genEndDate))
											duplicateExp = true;
								}                                
							}
						}
					}	
				}
				if(duplicateExp)
					errorMessage += "Duplicate -Records added for Exception Rule.<br>";
							
				for(int k=0; k<expProductSelect.length; k++)
				{
					if(expProductSelect[k].equals(""))
					{
						errorMessage += "Product  must be selected.<br/>";
						break;
					}
				}
				for( int i=0;i<bRStartExpmM.length;i++)
				{	 
					if( DateUtil.isDateValid( brStartExpDate[i] ) )
						genStartDate = DateUtil.toDate ( brStartExpDate[i] );
					else
					{
						errorMessage += "Start date is invalid.";
						break;
					}

					if( DateUtil.isDateValid( brEndExpDate[i] ) )
						genEndDate = DateUtil.toDate ( brEndExpDate[i] );
					else
					{
						errorMessage += "End date is invalid.<br>";
						break;
					}
					if( genStartDate != null && genEndDate != null)
					{
						if( genStartDate.after(genEndDate) )
						{
							errorMessage += "Start date cannot be greater than end date.<br>";
							break;
						}
					}
					
				 }
			}//Broker Restrictions
			if ((errorMessage.equals("") && totalList == null || totalList.size() == 0))
				errorMessage += "No changes made to Broker restriction(s).<br/>";
			
			if ((errorMessage.equals("") && totalList != null && totalList.size() > 0) && !"rework".equals(fromBack)) {
				fundFlag = true;
				
				productList = new ArrayList<String>();
				
				for(int prod=0; selectedProductName != null && prod<selectedProductName.length; prod++)
				{
					productList.add(selectedProductName[prod]);
				}	
				
				if(errorMessage.equals(""))
				{
					product.deleteBRVstatus(brokerRestrictionSelect, codeID1, codeID2, productNameFeat, "","","","","","","");
					dbErrorMessage = product.insertBrokerRestrictions(totalList, brokerRestrictionSelect);
				}
				for (int eCount = 0; dbErrorMessage != null && eCount < dbErrorMessage.length; eCount++) {
					if(!"".equals(dbErrorMessage[eCount]))
					{
						errorMessage += dbErrorMessage[eCount];
						break;
					}
				}
				if (errorMessage.equals("")) 
				{
					fundFlag = true;
					featFlag = true;
					RequestDispatcher dispatcher = pageContext.getServletContext().getRequestDispatcher(
							LANG_ROOT + "/rates/BrokerRestrictionVerify.jsp?strImplDate=" + strImplDate+"&submittedon="+prevSubmittedDt);
					dispatcher.forward(request, response);
					return;
				}
			}
		}//Next End	
		prevSubmittedDt = prevSubmittedDt.replace(" ","_");
		
 }//Post End
%>
<!doctype html public "-//w3c//dtd html 3.2 final//en">
<html>
<head>
<%@ include file="../include/datetabber.inc"%>
<%@ include file="../include/Header.inc"%>
<%@ include file="../include/tabs.inc"%>

<script src="../include/calendar_v11.js"></script>
<link rel="stylesheet" href="../../css/jquery-ui-1.8.13.custom.css" type="text/css">
<script type="text/javascript" src="../../js/jquery-1.6.1.min.js"></script>
<script type="text/javascript" src="../../js/jquery-ui-1.8.13.custom.min.js"></script>
<script type="text/javascript" src="../../js/ui.dropdownchecklist-1.4-min.js"></script>
<script type="text/javascript" src="combobox.js"></script>
<style type="text/css">
div.scrollNewRestriction{

  height:300px;
  width:100%;
  align:center;
  overflow:scroll;
}
</style>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<title>Admin Screens - Broker Restrictions</title>
<link rel="stylesheet" href="../css/<%=user.getStylesheet()%>">
<%
 subTab = BROKER_REST;
%>
</head>

<body bgcolor="#cccccc" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script language="javascript">

$(document).ready(function(){
    $("#productPlanID").dropdownchecklist( {  emptyText: "Please click to select",
        width: 300,height:150,forceMultiple: true
        , onComplete: function(selector) {
        	
        	inHTML = "";
            var values = "";           
                $("#productPlanID option:selected").each(
						function() {
							inHTML += '<option selected value="'
									+ $(this).val() + '">'
									+ $(this).text()
									+ '</option>';
						});
                $('#productPlanID option:not(:first)').remove();
                $("#productPlanID").append(inHTML);
                $('#productPlanID').find("option[value='0']").attr("selected","selected");
        }
     });

    $('#viewStateApproval').change(function(){
     	var plnCode = $( "#viewStateApproval" ).val();
     	var fundFeatID = $('#fundFeatID').val(); 
     	var codeString = $('#fundOrFeatSlID').val();
    	var FName = $('select#fundOrFeatSlID option:selected').text();
    	
    	//Start SCR58005
    	var regex = new RegExp('"', 'g');
    	var regex1 = new RegExp('&', 'g');
    	var regex2 = new RegExp('#', 'g');
    	if(FName.indexOf('"')!= -1)
    		FName = FName.replace(regex, '@');
    	if(FName.indexOf('&')!= -1)
    		FName = FName.replace(regex1, '_');
	if(FName.indexOf('#')!= -1)
    		FName = FName.replace(regex2, '*');	
		//End SCR58005
    	
     	var plnName = $('select#viewStateApproval option:selected').text();
     	var arr = codeString.split('#');
     	if(plnCode != '0')
     	{
     	 	var link = "BrokerRestrictionViewStateApp.jsp?restType="+fundFeatID+"&code1="+arr[0]+"&code2="+arr[1]+"&plnCode="+plnCode+"&FName="+FName+"&plnName="+plnName;
     		window.open(link,"sunsourcewindow","width=400,height=600,copyhistory=no,status=yes,scrollbars=yes,resizable=no,,left=0,top=0,screenX=0,screenY=0"); 
     	} 
     });
    
    $('#fundOrFeatSlID').change(function(){
    	
    	var codeString = $('#fundOrFeatSlID').val();
    	document.BrokerRestrictionsForm.submit();
    });
    var rowIndex = 1;
	$('#move_right').click(
			function() {
				inHTML = "";
				$("#source_select option:selected").each(
						function() {

							inHTML += '<option selected value="'
									+ $(this).val() + '">'
									+ $(this).text()
									+ '</option>';
						});
				$("#target_select option:first").val()
				$("#target option:selected").prop("selected", false);
				//$('#target_select option:not(:first)').remove();
				$("#target_select").append(inHTML);
				$('#source_select option:selected').remove();
				$('#target_select option').prop('selected', true);
				
				var bdid = [];
				$('.generalBDVal :selected').each(
						function(i, selected){
							bdid[i] = $(selected).val();
				}); 
				$('.generalBDVal').find("option").remove();
				
				//RAjendra
				 var inHTMLBDTxt = "<option value=0>--Selected Brokers--</option>";
			     var brokerList = document.getElementById('target_select');
			     for(var i = 0; i < brokerList.options.length; ++i)
			     {
			     	inHTMLBDTxt += "<option value=" + brokerList.options[i].value + ">" + brokerList.options[i].text + "</option>";
			     }     
			     var selectedBD = $('select.generalBDVal').find(':selected').val();
				 $('.generalBDVal').find("option").remove();
				 $('.generalBDVal').append(inHTMLBDTxt);
				 
				 for(var j=0; j<bdid.length;j++)
				 {
					$('.generalBDVal').each(function(index, currentElement){
					if(index == j )//&& $.inArray(bdid[j], brokerList) !== -1)
						$(currentElement).parent('td').parent('tr').find("option[value="+bdid[j]+"]").attr("selected","selected");
					 });
				}
			});
	$('#move_left').click(
			function() {
				inHTML2 = "";
				$("#target_select option:selected").each(
						function() {
							inHTML2 += '<option value="'+$(this).val()+'">'+ $(this).text()+'</option>';
						});
				$("#source_select").append(inHTML2);
				//$('#source_select option:not(:first)').remove();
				var bdid = [];
				$('.generalBDVal :selected').each(
						function(i, selected){
							bdid[i] = $(selected).val();
				}); 
				
				$('#target_select option:selected').remove();
				$('#target_select option').prop('selected', true);
                var inHTMLBDTxt = "<option value=0>--Selected Brokers--</option>";
			    var brokerList = document.getElementById('target_select');
			    for(var i = 0; i < brokerList.options.length; ++i)
			    {  
			       inHTMLBDTxt += "<option value=" + brokerList.options[i].value + ">" + brokerList.options[i].text + "</option>";
			    }     
				$('.generalBDVal').find("option").remove();
				$('.generalBDVal').append(inHTMLBDTxt);
				
				for(var j=0; j<bdid.length;j++)
				 {
					$('.generalBDVal').each(function(index, currentElement){
					if(index == j )//&& $.inArray(bdid[j], brokerList) !== -1)
						$(currentElement).parent('td').parent('tr').find("option[value="+bdid[j]+"]").attr("selected","selected");
					});
				}
			});
	$('#addGeneruleID').click(
			function() {
				var rowIndex = 1;
				var table = document.getElementById("brokerAddNewRowGenID");
				var newtr = document.createElement('tr');
				var newIndex = rowIndex + 1;
				newtr.setAttribute('id','trB'+newIndex);
				var td1 = document.createElement('td');
				newtr.style.cssText = "text-align: center;";
				var mon=0;
				var name;
				
				for ( i=0; i < document.BrokerRestrictionsForm.elements.length; i++)
				{
					name = document.BrokerRestrictionsForm.elements[i].name;
					if( name.substring(0, 16)=="brRestGenStartMM" )
					{
								mon++;
								
					}
				}
			td1.innerHTML = "<INPUT class=tabletextblack onkeydown=KeyDown(this,event) onkeyup=KeyPress(this,event) onfocus=gotFocus(this) maxLength=2 size=2 value='<%= sMonth %>' name=brRestGenStartMM"+mon+"> / "
				
		    	+"<INPUT class=tabletextblack onkeydown=KeyDown(this,event) onkeyup=KeyPress(this,event) onfocus=gotFocus(this) maxLength=2 size=2 value='<%= sDay %>' name=brRestGenStartDD"+mon+"> / "
				+"<INPUT class=tabletextblack onkeydown=KeyDown(this,event) onkeyup=KeyPress(this,event) onfocus=gotFocus(this) maxLength=4 size=4 value='<%= sYear %>' name=brRestGenStartYY"+mon+"> "
				+"<A onclick='g_Calendar.show(this, BrokerRestrictionsForm.brRestGenStartDD"+mon+", BrokerRestrictionsForm.brRestGenStartDD"+mon+", BrokerRestrictionsForm.brRestGenStartYY"+mon+")' href='javascript:void(0);'>"
				+"<IMG height=20 alt=Calendar src='<%=LANG_ROOT%>/newimages/calendar_v02.gif' width=23 border=0> </A>";

			var td2 = document.createElement('td');
			td2.innerHTML = "<INPUT class=tabletextblack onkeydown=KeyDown(this,event) onkeyup=KeyPress(this,event) onfocus=gotFocus(this) maxLength=2 size=2 value='<%= eMonth %>' name=brRestGenEndMM"+mon+"> / "
				+"<INPUT class=tabletextblack onkeydown=KeyDown(this,event) onkeyup=KeyPress(this,event) onfocus=gotFocus(this) maxLength=2 size=2 value='<%= eDay %>' name=brRestGenEndDD"+mon+"> / "
				+"<INPUT class=tabletextblack onkeydown=KeyDown(this,event) onkeyup=KeyPress(this,event) onfocus=gotFocus(this) maxLength=4 size=4 value='<%= eYear %>' name=brRestGenEndYY"+mon+"> "
				+"<A onclick='g_Calendar.show(this, BrokerRestrictionsForm.brRestGenEndMM"+mon+", BrokerRestrictionsForm.brRestGenEndDD"+mon+", BrokerRestrictionsForm.brRestGenEndYY"+mon+")' href='javascript:void(0);'>"
				+"<IMG height=20 alt=Calendar src='<%=LANG_ROOT%>/newimages/calendar_v02.gif' width=23 border=0> </A>"; 
				   
			var td3 = document.createElement('td');
				td3.className="tabletextblack";
				td3.innerHTML = "<INPUT maxLength='7' size='13' name='generalBD' value='<%=defBrokerID+"(All Brokers)"%>' style='font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 11px; width:150px; color: #000000; text-decoration: none;' disabled>";
				
			var td4 = document.createElement('td');
				td4.innerHTML = "<select name=genRestrict class='tabletextblack' >"
						+"<option value='0'>Yes</option>"
						+"<option value='1'>No</option>" 
						+"</select>";
						
			var inHTMLProductTxt = "";
			var fundFeat = $('#fundFeatID').val();
	        var inHTMLProductTxt = "";
	        
	        if(fundFeat == 'Fund')
		  	{	
	        	//inHTMLProductTxt +="<option value='All Selected Products'>All Selected Products</option>"
	        		$('#productPlanID :selected').each(
							function(i, selected){
								inHTMLProductTxt += "<option value="+$(selected).val()+">"+$(selected).text()+"</option>";
					});
	        
		  	}
	        
	        	var featVal =  $('select#productPlanID1 option:selected').val();
		      	var featText =  $('select#productPlanID1 option:selected').text();
		        if(fundFeat == 'Feature')
			  	{	
		        	inHTMLProductTxt +="<option value="+featVal+">"+featText+"</option>";
			  	}	
					var td5 = document.createElement('td');
					td5.innerHTML = "<select  name=productNameAdNew style='font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 11px; width:250px; color: #000000; text-decoration: none;' class='productNameAdNewID'>"
						+"<option value=''>--Select Product--</option>"
						+inHTMLProductTxt
						+"</select>";
						
						
					var td6 = document.createElement('td');

					td6.innerHTML = "<a href='javascript:void(0);' onclick='deleteBrokerRowGen(this);'> Delete </a>";				

					newtr.appendChild(td1);
					newtr.appendChild(td2);
					newtr.appendChild(td3);
					newtr.appendChild(td4);
					newtr.appendChild(td5);
					newtr.appendChild(td6);
					table.firstChild.appendChild(newtr);
				});
	$('#addExceptionalID').click(
		function() {
		    var table = document.getElementById("brokerAddNewRowExpID");
		    var rowIndex = 1;
		    var newtr = document.createElement('tr');
		    var newIndex = rowIndex + 1;
			    newtr.setAttribute('id','trE'+newIndex);
		    var td1 = document.createElement('td');
			    newtr.style.cssText = "text-align: center;";
			var mon=0;
			var name;
			for ( i=0; i < document.BrokerRestrictionsForm.elements.length; i++)
			{
			     name = document.BrokerRestrictionsForm.elements[i].name;
			     if( name.substring(0, 12)=="bRStartExpMM" )
			     {
			         mon++;
			      }
			}                                            
			td1.innerHTML = "<INPUT class=tabletextblack onkeydown=KeyDown(this,event) onkeyup=KeyPress(this,event) onfocus=gotFocus(this) maxLength=2 size=2 value='<%= sMonth %>' name=bRStartExpMM"+mon+"> / " 
			     +"<INPUT class=tabletextblack onkeydown=KeyDown(this,event) onkeyup=KeyPress(this,event) onfocus=gotFocus(this) maxLength=2 size=2 value='<%= sDay %>' name=bRStartExpDD"+mon+"> / "
			     +"<INPUT class=tabletextblack onkeydown=KeyDown(this,event) onkeyup=KeyPress(this,event) onfocus=gotFocus(this) maxLength=4 size=4 value='<%= sYear %>' name=bRStartExpYY"+mon+"> "
			     +"<A onclick='g_Calendar.show(this, BrokerRestrictionsForm.bRStartExpMM"+mon+", BrokerRestrictionsForm.bRStartExpDD"+mon+", BrokerRestrictionsForm.bRStartExpYY"+mon+")' href='javascript:void(0);'>"
			     +"<IMG height=20 alt=Calendar src='<%=LANG_ROOT%>/newimages/calendar_v02.gif' width=23 border=0> </A>";
			var td2 = document.createElement('td');
			td2.innerHTML = "<INPUT class=tabletextblack onkeydown=KeyDown(this,event) onkeyup=KeyPress(this,event) onfocus=gotFocus(this) maxLength=2 size=2 value='<%= eMonth %>' name=bREndExpMM"+mon+"> / "
			     +"<INPUT class=tabletextblack onkeydown=KeyDown(this,event) onkeyup=KeyPress(this,event) onfocus=gotFocus(this) maxLength=2 size=2 value='<%= eDay %>' name=bREndExpDD"+mon+"> / "
			     +"<INPUT class=tabletextblack onkeydown=KeyDown(this,event) onkeyup=KeyPress(this,event) onfocus=gotFocus(this) maxLength=4 size=4 value='<%= eYear %>' name=bREndExpYY"+mon+"> "
			     +"<A onclick='g_Calendar.show(this, BrokerRestrictionsForm.bREndExpMM"+mon+", BrokerRestrictionsForm.bREndExpDD"+mon+", BrokerRestrictionsForm.bREndExpYY"+mon+")' href='javascript:void(0);'>"
			     +"<IMG height=20 alt=Calendar src='<%=LANG_ROOT%>/newimages/calendar_v02.gif' width=23 border=0> </A>";
			        
			 var inHTMLBDTxt = "<option value='0'>--Selected Brokers--</option>";
			 var brokerList = document.getElementById('target_select');
			 for(var i = 0; i < brokerList.options.length; ++i)
			 {        	
			      inHTMLBDTxt += "<option value=" + brokerList.options[i].value + ">" + brokerList.options[i].text + "</option>";
			 }        
			 var td3 = document.createElement('td');        
			 td3.innerHTML = "<select class=generalBDVal name=exceptionalBD style='font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 11px; width:150px; color: #000000; text-decoration: none;'>"
			 + inHTMLBDTxt
			 +"</select>";      
			 var td4 = document.createElement('td');
			 td4.innerHTML = "<select name='expRestrict' class='tabletextblack' >"
			      +"<option value='0'>Yes</option>"
			      +"<option value='1'>No</option>" 
			      +"</select>";     
			 var fundFeat = $('#fundFeatID').val();
			 var inHTMLProductTxt = "";
			 if(fundFeat == 'Fund')
			 {	
			      $('#productPlanID :selected').each(
				  function(i, selected){
				       inHTMLProductTxt += "<option value="+$(selected).val()+">"+$(selected).text()+"</option>";
				 });
	 	     }
			 $('select#productPlanID1 option:selected').val();
			    var featVal =  $('select#productPlanID1 option:selected').val();
			    var featText =  $('select#productPlanID1 option:selected').text();
			    if(fundFeat == 'Feature')
			 	{	
			       	inHTMLProductTxt +="<option value="+featVal+">"+featText+"</option>";
			 	}
			    var td5 = document.createElement('td');
			    td5.innerHTML = "<select  name=productNameExNew style='font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 11px; width:250px; color: #000000; text-decoration: none;'>" 
				     +"<option value=''>--Select Product--</option>"
				     +inHTMLProductTxt
				     +"</select>";
		        var td6 = document.createElement('td');
					   td6.innerHTML = "<a href='javascript:void(0);' id='expAddNewRestDelete' onclick='deleteBrokerRowExp(this);'>Delete</a>";  
			      
			    newtr.appendChild(td1);
			    newtr.appendChild(td2);
			    newtr.appendChild(td3);
			    newtr.appendChild(td4);
			    newtr.appendChild(td5); 
			    newtr.appendChild(td6);
			    table.firstChild.appendChild(newtr);
		}); 

	$('.selectIDEditGen').change(function(){
	    if($(this).is(":checked"))
	    {
	   	 $(this).parent('td').parent('tr').find('.selectIDDeleteGen').prop("disabled", true);
	   	 $(this).parent('td').parent('tr').find('.currntGenRest').prop("disabled", false);
	 	 $(this).parent('td').parent('tr').find('.currGenEndMM').prop("disabled", false);
	   	 $(this).parent('td').parent('tr').find('.currGenEndDD').prop("disabled", false);
	   	 $(this).parent('td').parent('tr').find('.currGenEndYY').prop("disabled", false);
	    }
	    else
	    {
	   	 $(this).parent('td').parent('tr').find('.selectIDDeleteGen').prop("disabled", false);
	 	 $(this).parent('td').parent('tr').find('.currntGenRest').prop("disabled", true);
	   	 $(this).parent('td').parent('tr').find('.currGenEndMM').prop("disabled", true);
	   	 $(this).parent('td').parent('tr').find('.currGenEndDD').prop("disabled", true);
	   	 $(this).parent('td').parent('tr').find('.currGenEndYY').prop("disabled", true);
	   }
	   
	});
	$('.selectIDDeleteGen').change(function(){
	    if($(this).is(":checked"))
	    {
	   	 $(this).parent('td').parent('tr').find('.selectIDEditGen').prop("disabled", true);
	   	 $(this).parent('td').parent('tr').find('.currntGenRest').prop("disabled", true);
	   	 $(this).parent('td').parent('tr').find('.currGenEndMM').prop("disabled", true);
	   	 $(this).parent('td').parent('tr').find('.currGenEndDD').prop("disabled", true);
	   	 $(this).parent('td').parent('tr').find('.currGenEndYY').prop("disabled", true); 
	   
	   	 var genEndMM =  $(this).parent('td').parent('tr').find('.bRCurrntEndMMDC').val();
	   	 var genEndDD =  $(this).parent('td').parent('tr').find('.bRCurrntEndDDDC').val();
	   	 var genEndYY =  $(this).parent('td').parent('tr').find('.bRCurrntEndYYDC').val();
	   	
	   	 $(this).parent('td').parent('tr').find('.currGenEndMM').val(genEndMM);
	   	 $(this).parent('td').parent('tr').find('.currGenEndDD').val(genEndDD);
	   	 $(this).parent('td').parent('tr').find('.currGenEndYY').val(genEndYY);
	    }
	    else
	    {
	   	 	$(this).parent('td').parent('tr').find('.selectIDEditGen').prop("disabled", false);
	   		$(this).parent('td').parent('tr').find('.currntGenRest').prop("disabled", true);
	 		$(this).parent('td').parent('tr').find('.currGenEndMM').prop("disabled", true);
	   		$(this).parent('td').parent('tr').find('.currGenEndDD').prop("disabled", true);
	   		$(this).parent('td').parent('tr').find('.currGenEndYY').prop("disabled", true);
	   }
	});

	$('.selectIDEditExp').change(function(){
	    if($(this).is(":checked"))
	    {
	   	 $(this).parent('td').parent('tr').find('.selectIDDeleteExp').prop("disabled", true);
	   	 $(this).parent('td').parent('tr').find('.currntExcRest').prop("disabled", false);
	   	 $(this).parent('td').parent('tr').find('.currExpEndMM').prop("disabled", false);
	   	 $(this).parent('td').parent('tr').find('.currExpEndDD').prop("disabled", false);
	   	 $(this).parent('td').parent('tr').find('.currExpEndYY').prop("disabled", false);
	    }
	    else
	    {
	   	 $(this).parent('td').parent('tr').find('.selectIDDeleteExp').prop("disabled", false);
	   	 $(this).parent('td').parent('tr').find('.currntExcRest').prop("disabled", true);
	  	 $(this).parent('td').parent('tr').find('.currExpEndMM').prop("disabled", true);
	   	 $(this).parent('td').parent('tr').find('.currExpEndDD').prop("disabled", true);
	   	 $(this).parent('td').parent('tr').find('.currExpEndYY').prop("disabled", true);
	   }
	});
	$('.selectIDDeleteExp').change(function(){
	    if($(this).is(":checked"))
	    {
	   	 $(this).parent('td').parent('tr').find('.selectIDEditExp').prop("disabled", true);
	     $(this).parent('td').parent('tr').find('.currntExcRest').prop("disabled", true);
	   	 $(this).parent('td').parent('tr').find('.currExpEndMM').prop("disabled", true);
	   	 $(this).parent('td').parent('tr').find('.currExpEndDD').prop("disabled", true);
	   	 $(this).parent('td').parent('tr').find('.currExpEndYY').prop("disabled", true);
	   	
	   	 var genEndMM =  $(this).parent('td').parent('tr').find('.bRCurrntEndExpMMDC').val();
	   	 var genEndDD =  $(this).parent('td').parent('tr').find('.bRCurrntEndExpDDDC').val();
	   	 var genEndYY =  $(this).parent('td').parent('tr').find('.bRCurrntEndExpYYDC').val();
	   	
	   	 $(this).parent('td').parent('tr').find('.currExpEndMM').val(genEndMM);
	   	 $(this).parent('td').parent('tr').find('.currExpEndDD').val(genEndDD);
	   	 $(this).parent('td').parent('tr').find('.currExpEndYY').val(genEndYY);
	    }
	    else
	    {
		   	 $(this).parent('td').parent('tr').find('.selectIDEditExp').prop("disabled", false);
		   	 $(this).parent('td').parent('tr').find('.currntExcRest').prop("disabled", true);
			 $(this).parent('td').parent('tr').find('.currExpEndMM').prop("disabled", true);
		   	 $(this).parent('td').parent('tr').find('.currExpEndDD').prop("disabled", true);
		   	 $(this).parent('td').parent('tr').find('.currExpEndYY').prop("disabled", true);
	   }
	});
	
	 $('.currntGenRest').attr('disabled', 'disabled');
	 $('.currntExcRest').attr('disabled', 'disabled');
	 
	 $('.currGenEndMM').attr('disabled', 'disabled');
	 $('.currGenEndDD').attr('disabled', 'disabled');
	 $('.currGenEndYY').attr('disabled', 'disabled');
	
	 $('.currExpEndMM').attr('disabled', 'disabled');
	 $('.currExpEndDD').attr('disabled', 'disabled');
	 $('.currExpEndYY').attr('disabled', 'disabled');
	
	 $('.selectIDEditGen:checked').change();
	 $('.selectIDDeleteGen:checked').change();
	 $('.selectIDEditExp:checked').change();
	 $('.selectIDDeleteExp:checked').change();
	/*  
	 $('#productPlanID').change(function()
	{
		var selectPlan = "$$$";

		  $("#productPlanID option:selected").each(
			function() {
				selectPlan +=$(this).val()"#";
			}); 
		 if(!(selectPlan == ""))
		 {
			//var url="http://localhost:8080/en/rates/BrokerRestrictionsAjax.jsp?selectPlan="+selectPlan;
			var url="http://localhost:8080/en/rates/BrokerRestrictionsAjax.jsp?selectPlan=$$$";
		 }

		if(window.XMLHttpRequest)
		{
			request=new XMLHttpRequest();
		}
		else if(window.ActiveXObject)
		{
			request=new ActiveXObject("Microsoft.XMLHTTP");
		} 
		try
		{
			var val=request.responseText;
			request.onreadystatechange=getInfo;
			request.open("GET",url,true);
			request.send();
		}
		catch(e)
		{
			alert("Unable to connect to server");
		} 
	 });
	  */
});
function deleteBrokerRowGen(thisObject)
{
	 var table = document.getElementById('brokerAddNewRowGenID');
	 table.firstChild.removeChild(thisObject.parentNode.parentNode);
}
function deleteBrokerRowExp(thisObject)
{
	var table = document.getElementById('brokerAddNewRowExpID');
	 table.firstChild.removeChild(thisObject.parentNode.parentNode);
}
function disp(a, b)
{
	document.BrokerRestrictionsForm.submit();
}
function currentRestCal(thisVar, month, date, year)
{	
	var edit = $(this).parent('td').parent('tr').find('.selectIDEditExp').prop('checked');
	
	return g_Calendar.show(thisVar, month, date,year)
} 

/* function getInfo()
{
	if(request.readyState==4)
	{
		var val=request.responseText;
		alert(val);
		//$("#target_select").append(val);
	}
}  */
 </script>

<!-- Begin Light Orange Area -->
<table border="0" cellpadding="0" cellspacing="0" width="100%">
 <tr>
  <td bgcolor="#ffcc66"><img src="<%=LANG_ROOT%><%=newImages%>/spacer.gif" alt="" border="0" width="5" height="30"></td>
  	<td bgcolor="#ffcc66" class="tabletextblack"><b>View/Add Broker Restriction</b></td>
  	<td bgcolor="#ffcc66"><img src="<%=LANG_ROOT%><%=newImages%>/spacer.gif" alt="" border="0" width="300" height="30"></td>
	 <td align=right bgColor="#ffcc66">
	<td bgcolor="#ffcc66" align="right" >&nbsp;</td>
 </tr>
</table>
<table border="0" cellpadding="0" cellspacing="0" width="100%">
<FORM NAME="BrokerRestrictionsForm" METHOD="post" ACTION="BrokerRestrictionsApply.jsp">
 <table border="0" cellpadding="2%" cellspacing="0%" width="100%">
 <tr> 
 <td class="tabletextwhite" bgcolor="#999999" nowrap="nowrap" width="4%"><b>Broker Restriction</b></td>
 <td class="tabletextwhite" bgcolor="#999999" nowrap="nowrap">
 <select  name="fundOrFeatOrPlan" id='fundFeatID' class="tabletextblack" onChange="javascript:document.BrokerRestrictionsForm.submit();"> 
 <%
 	if(brokerRestrictionSelect.equalsIgnoreCase("Feature"))
 		selectedFeat = "selected";
 %>
 	<option value="Fund">Fund Restriction</option>
 	<option  <%=selectedFeat %> value="Feature">Feature Restriction</option>
 </select>
 </td>
 <td bgcolor="#999999"><img src="<%=LANG_ROOT%><%=newImages%>/spacer.gif" alt="" border="0" width="10" height="1"></td>
 </tr>
</table>
<%
if( errorMessage != null && (!errorMessage.equals("")))
	{
	%>
		 <ul><%=sWarning%><span class="ErrorMessage"><%= errorMessage %></span></ul>
	<%
	}
%>
<!-- End Error Message Area //-->
<table border=0 cellPadding=0 cellSpacing=0 width="90%" align="center">
<tr>
<td colspan="0"><img src="<%=LANG_ROOT%><%=newImages%>/spacer.gif" alt="" border="0" width="1" height="20"></td>
<td colspan="0"><img src="<%=LANG_ROOT%><%=newImages%>/spacer.gif" alt="" border="0" width="1" height="20"></td>
</tr>
<tr>
<td class="tabletextgrey" nowrap>Product Family</td>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<td class="tabletextblack">
<select   name="productFamily" class="tabletextblack"  onChange="javascript:disp(this.selectedIndex, 1);">
<%
	String selectedV = "";
	String selectedI = "";
	if("Index".equals(productFamily))
		selectedI = "selected";
	if("Variable".equals(productFamily))
		selectedV = "selected";
%>
 <option value='0'>--Selection--</option>
 <option <%=selectedI%> value='Index'>Index</option>
<option <%=selectedV%> value='Variable'>Variable</option>
</select>
</td>
<%
if("Fund".equals(brokerRestrictionSelect))
{
%>
<td class="tabletextgrey" nowrap >&nbsp;&nbsp; Product Type </td>
<td class="tabletextblack">
<select   name="productFamily1" style="width:200px" class="tabletextblack"  onChange="javascript:disp(this.selectedIndex, 1);">
<option selected value=''>--Selection--</option>
<%
if(productFamilyMap !=null )
{
	String value = "";
	String select = "";
	Integer keyValue = new Integer(0);
	for(Integer key : productFamilyMap.keySet())
	{
		select = "";
		value = productFamilyMap.get(key);
		keyValue = key;
		if(!"".equals(productFamily1))
		{	
			if(key == Integer.parseInt(productFamily1))
			select = "selected"; 
		}
	%>
	<option <%=select %> value='<%=keyValue %>'><%=value %></option>
	<%
	}
}
%>
</select>
</td>
<%
}%>
<%
if("Feature".equalsIgnoreCase(brokerRestrictionSelect))
{
%>
<td align=right class=tabletextgrey>Product &nbsp;&nbsp;&nbsp;&nbsp;</td>
	<td class="tabletextblack" >
	<select    name="productNameFeat" style="width:200px;" id='productPlanID1' class="tabletextblack" onChange="javascript:disp(this.selectedIndex, 2);">
	<option value='0'>--Select Product--</option>
  <%
  	for(int k=0; productPlanList!= null && k<productPlanList.size();k++)
  	{	
  		String selected = "";
  		BrokerRestriction brProducts = productPlanList.get(k);
  			if((brProducts.planCode).equals(productNameFeat))
	  			selected = "selected";
  %>
  <option <%=selected%> value='<%=brProducts.planCode%>'><%=brProducts.desc%></option>
 <%
	}
%> 
</select>
</td>
<%
}
%>
<td align=right class="tabletextgrey"  ><%=brokerRestrictionSelect%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
<td class="tabletextblack"  >
 <select   name="fundOrFeature" class="tabletextblack" id='fundOrFeatSlID' style="width:300px;">
 <option value='0'>--Select <%=brokerRestrictionSelect%>--</option>
<%
  BrokerRestriction br = null;
  	for(int i=0; brFundorFeatList!=null && i<brFundorFeatList.size();i++)
  	{	
  		String selected = "";
  		br = brFundorFeatList.get(i);
  		if(!brokerRestrictionSelect.equalsIgnoreCase("Feature"))
  	 	{	
  			if(selectedFundOrFeat.equals(br.accountCode+"#"+br.divisionCode))
  			{
  				selected = "selected";
  				slctRestName = 	br.desc;
			}
  	  			String displayValue =  br.desc+" ("+br.accountCode+"-"+br.divisionCode+")";
  		%>
  		<option <%=selected%> value='<%=br.accountCode%>#<%=br.divisionCode%>'><%=displayValue%></option>
  		
  		<%
  	 	}
  		else
  		{
  			if(selectedFundOrFeat.equals(br.specCode+"#"+br.variationID))
  			{
  				selected = "selected";
  				
  				slctRestName = 	br.desc;
  			}
  		%>
  		<option <%=selected%> value='<%=br.specCode%>#<%=br.variationID%>' <%=selected %>><%=br.desc%></option>
  		
  		<%
  		}
  	}
%>
 </select>
 </td>
 <td class="tabletextblack" align="left" width="1"><input name="search" align="middle" type="image" alt="Click here to begin search" src="/en/newimages/b_search_o_ffffff.gif" border="0" value="search"/>
</td>
</tr>
<tr>
<td colspan="0"><img src="<%=LANG_ROOT%><%=newImages%>/spacer.gif" alt="" border="0" width="1" height="20"></td>
<td colspan="0"><img src="<%=LANG_ROOT%><%=newImages%>/spacer.gif" alt="" border="0" width="1" height="20"></td>
</tr>
</table>
<!-- after selecting fund or feature  -->
<%
if(productPlanList != null  && brFundorFeatList != null && (featFlag || fundFlag))
{
%>
<table border=0 cellPadding=0 cellSpacing=0 width="100%">
<tr>
<td width="100%" height="20" class="tabletextwhite" bgcolor="#999999"><b>Add Broker Restriction</b>
</tr>
</table>
<!-- Starting position  -->
<BR/>
<table border=0 cellPadding=0 cellSpacing=0 width="100%">
<tr>
<td class="tabletextgrey" width="20%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; System Effective Date &nbsp;&nbsp;
	<INPUT  class=tabletextblack onkeydown=KeyDown(this,event); onkeyup=KeyPress(this,event); onfocus=gotFocus(this); maxLength=2 size=2 value="<%= implStartMM %>" name=implStartmM> /
	<INPUT class=tabletextblack onkeydown=KeyDown(this,event); onkeyup=KeyPress(this,event); onfocus=gotFocus(this); maxLength=2 size=2 value="<%= implStartDD %>" name=implStartdD> /
	<INPUT class=tabletextblack onkeydown=KeyDown(this,event); onkeyup=KeyPress(this,event); onfocus=gotFocus(this); maxLength=4 size=4 value="<%= implStartYY %>" name=implStartyY>
	<A onclick="g_Calendar.show(this, BrokerRestrictionsForm.implStartmM, BrokerRestrictionsForm.implStartdD, BrokerRestrictionsForm.implStartyY)" href="javascript:void(0);">
	<IMG height=20 alt=Calendar src="<%=LANG_ROOT%><%=newImages%>/calendar_v02.gif" width=23 border=0> </A>
</td>
<td class=tabletextblack  width="1%"></td>
<%
if(brokerRestrictionSelect.equalsIgnoreCase("Fund"))
{
%>
<td width="7%" valign="top" nowrap="nowrap" class=tabletextgrey align="right">Product &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
	<td width="20%" valign="top" nowrap="nowrap" class=tabletextgrey align="left">
	<table cellSpacing=0 cellPadding=0 width="20%" border="1" style="margin-left:1px;">
		<tr><td class=tabletextblack width="20%" >
	<select   name="productName" multiple="multiple" id='productPlanID' class="tabletextblack" onChange="javascript:document.BrokerRestrictionsForm.submit();">  
  <%
 
  	for(int k=0; productPlanList != null && k<productPlanList.size();k++)
  	{	
  		String selected = "";	
  	
  		BrokerRestriction brProducts = productPlanList.get(k);
  		for(int i=0; null!=selectedProductName && i<selectedProductName.length;i++)
  		{	
  			if(brProducts.planCode.equals(selectedProductName[i]))
  			{
	  			selected = "selected";
  			}
  		}
  %>
  <option <%=selected%> value='<%=brProducts.planCode%>'><%=brProducts.desc%></option>
 <%
	}
  
%> 
</select>
</td></tr></table></td>
<%
}
%>
</tr>
</table>

<table border=0 cellPadding=0 cellSpacing=0 width="100%">
<tr>
<td class=tabletextgrey border="0" nowrap="nowrap" width="20%" align="right"><BR/><BR/>Broker Dealer &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<br/><br/>
  <select   name="from" id="source_select" size="9" style="width:250px" multiple="multiple" class="tabletextblack" >
  <option disabled value='0'>--Select Brokers--</option>
  <%
  if(brokerDealerMap != null)
  {   
	boolean flagVal = false; 
	for(String bdKey : brokerDealerMap.keySet())
	{
  		String brDealer = brokerDealerMap.get(bdKey);
  		flagVal = false;
  		for(int cnt=0; selectedToBdList != null && cnt < selectedToBdList.length; cnt++)
  		{
  			if(selectedToBdList[cnt].equals(bdKey))
  				flagVal = true;
  		}
  		if("null".equals(brDealer) || null == brDealer || flagVal)
			continue;
  %>
  <option value="<%=bdKey%>"><%=brDealer%></option>
 <%
	}
  }
%>    
</select>
</td>
<td class=tabletextblack  width="3%" align="center">
    
    <input   type="button" id="move_right" class="btn btn-block" value=' >> '/><br/>
    <input    type="button" id="move_left" class="btn btn-block" value=' << '/><br/>
    
</td>
<td class=tabletextblack width="60%" align="left"><br/><br/>
<BR/><BR/>
    <select  name="toBDList" id="target_select" size="9" style="width:250px" multiple="multiple" class="tabletextblack" >
    <%
    	for(int i = 0; brokerDealerMap !=null && selectedToBdList != null && i<selectedToBdList.length; i++)
    	{	
    		String toBrDetails =  brokerDealerMap.get(selectedToBdList[i]);
    		if("null".equals(toBrDetails) || null == toBrDetails)
    			continue;
    %>
    <option selected value="<%=selectedToBdList[i]%>"><%=toBrDetails%></option>
    <%
    	}
    %>
    </select>
</td>
</tr>
<tr>
<td colspan="0"><img src="<%=LANG_ROOT%><%=newImages%>/spacer.gif" alt="" border="0" width="1" height="20"></td>
<td colspan="0"><img src="<%=LANG_ROOT%><%=newImages%>/spacer.gif" alt="" border="0" width="1" height="20"></td>
</tr>
</table>
<!-- Ending position  -->

<table border=0 cellPadding=0 cellSpacing=0 width="100%">
<tr>
<td width="100%" height="20" class="tabletextwhite" bgcolor="#999999"><b>Current Restriction(s)</b></td>
</tr>
</table>
<BR/>

<table border="1%" cellpadding="0" cellspacing="0" align="center" width="95%">
<tr>
<td class="tabletextwhite" width="-1%" nowrap="nowrap"></td>
<td class="tabletextwhite" width="100%" nowrap="nowrap">

<div class="scrollNewRestriction" >
<table border=0 cellPadding=0 cellSpacing=0 width="100%">
<tr>
<tr>

<table cellSpacing=1 cellPadding=1 width="100%" bgColor=#ffffff border=0 >
	<tbody >
	<tr><br/>
			<th class="tabletextblack" align="left">General Rule(s)</th>
			<td></td>			
			<td></td>
			<td></td>
			<td></td>
	</tr>
	<tr>
		<th bgcolor="#999999" class="tabletextwhite" width="5%">Eff Date</th>
		<th bgcolor="#999999" class="tabletextwhite" width="5%">End Date</th>
		<th bgcolor="#999999" class="tabletextwhite" width="7%">BD ID</th>
		<th bgcolor="#999999" class="tabletextwhite" width="2%">Restrict</th>
		<th bgcolor="#999999" class="tabletextwhite" width="6%">Product</th>
		<th bgcolor="#999999" class="tabletextwhite" width="2%">Update</th>
		<th bgcolor="#999999" class="tabletextwhite" width="2%">Delete</th>		
		
	</tr>
	<%
	if(currentRestrictionList != null)
	{
		int i = 0;
		String cEditCheck = "";
		String cDeleteCheck = "";
		for(int count = 0; count<currentRestrictionList.size();count++)
		{
			cEditCheck = "";
			cDeleteCheck = "";
			BrokerRestriction currentBrokerRest = currentRestrictionList.get(count);
			
			if(currentBrokerRest.brokerID.equals("-999"))
			{
				
				String currentGenStartMM = ""+DateUtil.getMonth(currentBrokerRest.rateStartdate);
				currentGenStartMM = (currentGenStartMM.length() > 1) ? currentGenStartMM : "0" + currentGenStartMM;
				String currentGenStartDD = ""+DateUtil.getDay(currentBrokerRest.rateStartdate);
				currentGenStartDD = (currentGenStartDD.length() > 1) ? currentGenStartDD : "0" + currentGenStartDD;
				String currentGenStartYY = ""+DateUtil.getYear(currentBrokerRest.rateStartdate);
				
				String currentGenEndMM = "";
				String currentGenEndDD = "";
				String currentGenEndYY = "";
				
				String restrictions = "";
				
				if(slCurrntGenrestrict != null && slCurrntGenrestrict.length >0 && "1".equals(cEditGen[i]))
					restrictions = slCurrntGenrestrict[i];
				else
					restrictions = currentBrokerRest.restrictionStatus;
				
				if(cEditGen != null && cEditGen.length >0 && "1".equals(cEditGen[i]))
				{
					currentGenEndMM = ""+DateUtil.getMonth(cEndDtGen[i]);
					currentGenEndMM = (currentGenEndMM.length() > 1) ? currentGenEndMM : "0" + currentGenEndMM;
					currentGenEndDD = ""+DateUtil.getDay(cEndDtGen[i]);
					currentGenEndDD = (currentGenEndDD.length() > 1) ? currentGenEndDD : "0" + currentGenEndDD;
					currentGenEndYY = ""+DateUtil.getYear(cEndDtGen[i]);
				}
				else
				{
					currentGenEndMM = ""+DateUtil.getMonth(currentBrokerRest.rateEnddate);
					currentGenEndMM = (currentGenEndMM.length() > 1) ? currentGenEndMM : "0" + currentGenEndMM;
					currentGenEndDD = ""+DateUtil.getDay(currentBrokerRest.rateEnddate);
					currentGenEndDD = (currentGenEndDD.length() > 1) ? currentGenEndDD : "0" + currentGenEndDD;
					currentGenEndYY = ""+DateUtil.getYear(currentBrokerRest.rateEnddate);
				}
			
	%>
	<tr id="trB1">
		<td align="center" width="1%">
			<INPUT   class=tabletextblack onkeydown=KeyDown(this,event); onkeyup=KeyPress(this,event); onfocus=gotFocus(this); maxLength=2 size=2 disabled="disabled" value="<%= currentGenStartMM %>" > /
			<INPUT   class=tabletextblack onkeydown=KeyDown(this,event); onkeyup=KeyPress(this,event); onfocus=gotFocus(this); maxLength=2 size=2 disabled="disabled" value="<%= currentGenStartDD %>" > /
			<INPUT   class=tabletextblack onkeydown=KeyDown(this,event); onkeyup=KeyPress(this,event); onfocus=gotFocus(this); maxLength=4 size=4 disabled="disabled" value="<%= currentGenStartYY %>" >
			<A href="javascript:void(0);">
			<IMG height=20 alt=Calendar src="<%=LANG_ROOT%><%=newImages%>/calendar_v02.gif" width=23 border=0> </A>
			<input type='hidden' value="<%= currentGenStartMM %>" name="bRCurrntStartMM<%=i%>"/>
			<input type='hidden' value="<%= currentGenStartDD %>" name="bRCurrntStartDD<%=i%>"/>
			<input type='hidden' value="<%= currentGenStartYY %>" name="bRCurrntStartYY<%=i%>"/>
		</td>
		<td align="center" width="1%">
			<INPUT   class=currGenEndMM onkeydown=KeyDown(this,event); onkeyup=KeyPress(this,event); onfocus=gotFocus(this); maxLength=2 size=2  value="<%= currentGenEndMM %>" name="bRCurrntEndMM<%=i%>" style="font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 11px; color: #000000; text-decoration: none;" > /
			<INPUT   class=currGenEndDD onkeydown=KeyDown(this,event); onkeyup=KeyPress(this,event); onfocus=gotFocus(this); maxLength=2 size=2  value="<%= currentGenEndDD %>" name="bRCurrntEndDD<%=i%>" style="font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 11px; color: #000000; text-decoration: none;"> /
			<INPUT   class=currGenEndYY onkeydown=KeyDown(this,event); onkeyup=KeyPress(this,event); onfocus=gotFocus(this); maxLength=4 size=4  value="<%= currentGenEndYY %>" name="bRCurrntEndYY<%=i%>" style="font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 11px; color: #000000; text-decoration: none;">
			<A   onclick="g_Calendar.show(this, BrokerRestrictionsForm.bRCurrntEndMM<%=i%>, BrokerRestrictionsForm.bRCurrntEndDD<%=i%>, BrokerRestrictionsForm.bRCurrntEndYY<%=i%>)" href="javascript:void(0);">
			<IMG height=20 alt=Calendar src="<%=LANG_ROOT%><%=newImages%>/calendar_v02.gif" width=23 border=0> </A>
			<input type='hidden' value="<%= currentGenEndMM %>" name="bRCurrntEndMMD<%=i%>" class='bRCurrntEndMMDC'/>
			<input type='hidden' value="<%= currentGenEndDD %>" name="bRCurrntEndDDD<%=i%>" class='bRCurrntEndDDDC'/>
			<input type='hidden' value="<%= currentGenEndYY %>" name="bRCurrntEndYYD<%=i%>" class='bRCurrntEndYYDC'/>
		</td>
		<td align="center" class=tabletextblack width="1%" >
		&nbsp;&nbsp;&nbsp;<%=defBrokerID+"(All Brokers)"%>
			<input type="hidden" name="currentGenBDID" value='-999' readonly  class=tabletextblack>
		</td>
		<td align="center" class="tabletextblack">
		<select   name="currntGenrestrict<%=i%>"  class='currntGenRest' style="font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 11px; color: #000000; text-decoration: none;">
			<option value="0">Yes</option>
			<option <%=("1".equals(restrictions))?"selected":""%> value="1">No</option>
		</select>
		<input type="hidden" value='<%=restrictions %>' name='currntGenRestD<%=i%>'/>
		</td>
		<td align="center" class=tabletextblack>
		<%
		String productName =currentBrokerRest.desc;
		if((currentBrokerRest.desc).equalsIgnoreCase("Default"))
		{
			productName = "All Products";
		%>
		&nbsp;&nbsp;&nbsp;<%=productName%>
		<%
		}
		else
		{
		%>
		&nbsp;&nbsp;&nbsp;<%=productName%>
		<%
		}
		%>
		<input type="hidden"  name="currentGenProduct<%=i%>"  value="<%=currentBrokerRest.planCode%>">
		</td>
		<%
		if(cEditGen != null && "1".equals(cEditGen[i]))
			cEditCheck = "checked";
		if(fromBack.equals("back") || fromBack.equals("rework"))
			cEditCheck = BrokerRestriction.BR_RESTRICTION_UPDATE.equals(currentBrokerRest.action)?"checked":"";
		%>    
		<td align="center"><input   type="checkbox" value="1"  <%=cEditCheck %> name="selectAllEditGen<%=i%>" class="selectIDEditGen"  ></td>  
		<%
		if(cDeleteGen != null && cDeleteGen.length >0 && !(fromBack.equals("back") && fromBack.equals("rework")))
			cDeleteCheck = "1".equals(cDeleteGen[i])?"checked":"";
		if(fromBack.equals("back") || fromBack.equals("rework"))
			cDeleteCheck = BrokerRestriction.BR_RESTRICTION_DELETE.equals(currentBrokerRest.action)?"checked":"";
		%> 
		<td align="center"><input   type="checkbox"  value="1" <%=cDeleteCheck %> name="selectAllDeleteGen<%=i%>" class="selectIDDeleteGen" ></td>  
	</tr>
	<%
	i++;
	}
	}
}
%>
	</tbody>
</table>
<table cellSpacing=1 cellPadding=1 width="100%" bgColor=#ffffff border=0 >
	<tbody>
		<tr><br/>
			<th class="tabletextblack" align="left">Exceptional Rule(s)</th>
			<th></th>
			<th></th>
			<th></th>
			<th></th>
		</tr>
		<tr>
			<th bgcolor="#999999" class="tabletextwhite" width="5%">Eff Date</th>
			<th bgcolor="#999999" class="tabletextwhite" width="5%">End Date</th>
			<th  bgcolor="#999999" class="tabletextwhite" width="7%">BD ID</th>
			<th bgcolor="#999999" class="tabletextwhite" width="2%">Restrict</th>
			<th bgcolor="#999999" class="tabletextwhite" width="6%">Product</th>
			<th bgcolor="#999999" class="tabletextwhite" width="2%">Update</th>
			<th bgcolor="#999999" class="tabletextwhite" width="2%">Delete</th>
			
		</tr>
		<%
	if(currentRestrictionList != null)
	{
		int i = 0;
		String checkedE = "";
		String checkedD = "";
		for(int count = 0; count<currentRestrictionList.size();count++)
		{
			checkedE = "";
			checkedD = "";
			BrokerRestriction currentBrokerRest = currentRestrictionList.get(count);
			if(!currentBrokerRest.brokerID.equals("-999"))
			{
				String currentExpStartMM = ""+DateUtil.getMonth(currentBrokerRest.rateStartdate);
				currentExpStartMM = (currentExpStartMM.length() > 1) ? currentExpStartMM : "0" + currentExpStartMM;
				String currentExpStartDD = ""+DateUtil.getDay(currentBrokerRest.rateStartdate);
				currentExpStartDD = (currentExpStartDD.length() > 1) ? currentExpStartDD : "0" + currentExpStartDD;
				String currentExpStartYY = ""+DateUtil.getYear(currentBrokerRest.rateStartdate);
				
				String restrictionExp = "";
				
				if(slCurrentRestrictExp != null && slCurrentRestrictExp.length >0 && "1".equals(cEditExp[i]))
					restrictionExp = slCurrentRestrictExp[i];
				else
					restrictionExp = currentBrokerRest.restrictionStatus;
				
				String currentExpEndMM = "";
				String currentExpEndDD = "";
				String currentExpEndYY = "";
				
				if(cEditExp != null && cEditExp.length >0 && "1".equals(cEditExp[i]))
				{
					currentExpEndMM = ""+DateUtil.getMonth(cEndDtExp[i]);
					currentExpEndMM = (currentExpEndMM.length() > 1) ? currentExpEndMM : "0" + currentExpEndMM;
					currentExpEndDD = ""+DateUtil.getDay(cEndDtExp[i]);
					currentExpEndDD = (currentExpEndDD.length() > 1) ? currentExpEndDD : "0" + currentExpEndDD;
					currentExpEndYY = ""+DateUtil.getYear(cEndDtExp[i]);
				}
				else
				{
					currentExpEndMM = ""+DateUtil.getMonth(currentBrokerRest.rateEnddate);
					currentExpEndMM = (currentExpEndMM.length() > 1) ? currentExpEndMM : "0" + currentExpEndMM;
					currentExpEndDD = ""+DateUtil.getDay(currentBrokerRest.rateEnddate);
					currentExpEndDD = (currentExpEndDD.length() > 1) ? currentExpEndDD : "0" + currentExpEndDD;
					currentExpEndYY = ""+DateUtil.getYear(currentBrokerRest.rateEnddate);
				}
	%>
<tr>
<td align="center" width="1%">
	<INPUT class=tabletextblack onkeydown=KeyDown(this,event); onkeyup=KeyPress(this,event); onfocus=gotFocus(this); maxLength=2 size=2 disabled='disabled' value="<%= currentExpStartMM %>" > /
	<INPUT class=tabletextblack onkeydown=KeyDown(this,event); onkeyup=KeyPress(this,event); onfocus=gotFocus(this); maxLength=2 size=2 disabled='disabled' value="<%= currentExpStartDD %>" > /
	<INPUT class=tabletextblack onkeydown=KeyDown(this,event); onkeyup=KeyPress(this,event); onfocus=gotFocus(this); maxLength=4 size=4 disabled='disabled' value="<%= currentExpStartYY %>" >
	<A href="javascript:void(0);">
	<IMG height=20 alt=Calendar src="<%=LANG_ROOT%><%=newImages%>/calendar_v02.gif" width=23 border=0> </A>
	<input type='hidden' value="<%= currentExpStartMM %>" name="bRCurrntStartExpMM<%=i%>"/>
	<input type='hidden' value="<%= currentExpStartDD %>" name="bRCurrntStartExpDD<%=i%>"/>
	<input type='hidden' value="<%= currentExpStartYY %>" name="bRCurrntStartExpYY<%=i%>"/>
</td>
<td align="center" width="1%">
	<INPUT   class=currExpEndMM onkeydown=KeyDown(this,event); onkeyup=KeyPress(this,event); onfocus=gotFocus(this); maxLength=2 size=2 value="<%= currentExpEndMM %>" name="bRCurrntEndExpMM<%=i%>" style="font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 11px; color: #000000; text-decoration: none;"> /
	<INPUT   class=currExpEndDD onkeydown=KeyDown(this,event); onkeyup=KeyPress(this,event); onfocus=gotFocus(this); maxLength=2 size=2 value="<%= currentExpEndDD %>" name="bRCurrntEndExpDD<%=i%>" style="font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 11px; color: #000000; text-decoration: none;"> /
	<INPUT   class=currExpEndYY onkeydown=KeyDown(this,event); onkeyup=KeyPress(this,event); onfocus=gotFocus(this); maxLength=4 size=4 value="<%= currentExpEndYY %>" name="bRCurrntEndExpYY<%=i%>" style="font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 11px; color: #000000; text-decoration: none;">
	<A   onclick="g_Calendar.show(this, BrokerRestrictionsForm.bRCurrntEndExpMM<%=i%>, BrokerRestrictionsForm.bRCurrntEndExpDD<%=i%>, BrokerRestrictionsForm.bRCurrntEndExpYY<%=i%>)" href="javascript:void(0);">
	<IMG height=20 alt=Calendar src="<%=LANG_ROOT%><%=newImages%>/calendar_v02.gif" width=23 border=0> </A>
	<input type='hidden' value="<%= currentExpEndMM %>" name="bRCurrntEndExpMMD<%=i%>" class='bRCurrntEndExpMMDC'/>
	<input type='hidden' value="<%= currentExpEndDD %>" name="bRCurrntEndExpDDD<%=i%>" class='bRCurrntEndExpDDDC'/>
	<input type='hidden' value="<%= currentExpEndYY %>" name="bRCurrntEndExpYYD<%=i%>" class='bRCurrntEndExpYYDC'/>
<td  align="center" width="1%" class=tabletextblack>
	&nbsp;&nbsp;&nbsp;<%=currentBrokerRest.brokerID%>
	<input  type="hidden" name="currentExpBD<%=i%>" value="<%=currentBrokerRest.brID%>" readonly> 
	<input  type="hidden" name="currentExpBDID" value="<%=currentBrokerRest.brokerID%>" >

</td>
		<td align="center">
		<select name="currentExcRestrict<%=i%>" class='currntExcRest' style="font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 11px; color: #000000; text-decoration: none;">
			<option value="0">Yes</option>
			<option <%=("1".equals(restrictionExp))?"selected":""%> value="1">No</option>
		</select>
		<input type="hidden" value='<%=restrictionExp %>' name='currentExcRestrictD<%=i %>'/>

		</td>
		<td align="center" class=tabletextblack>
		<%
		String prodName = currentBrokerRest.desc;
		if((currentBrokerRest.desc).equals("Default"))
		{
			prodName="All Products";
		%>
			&nbsp;&nbsp;&nbsp;<%=prodName %>
		<%
		}
		else
		{
		%>
			<%=currentBrokerRest.desc%>
		<%
		}
		%>
		<input type="hidden" class="tabletextblack"  name="currentExpProduct<%=i%>"  value="<%=currentBrokerRest.planCode%>" >
		</td>
		<%
		if(cEditExp != null && "1".equals(cEditExp[i]))
			checkedE = "checked";		
		if(fromBack.equals("back") || fromBack.equals("rework"))
			checkedE = BrokerRestriction.BR_RESTRICTION_UPDATE.equals(currentBrokerRest.action)?"checked":"";
		%>
		<td align="center"><input   <%=checkedE%> type="checkbox" value="1" name="selectAllEditExp<%=i%>" class="selectIDEditExp" ></td>
		<%
		if(cDeleteExp != null && "1".equals(cDeleteExp[i]))
			checkedD = "checked";
		if(fromBack.equals("back") || fromBack.equals("rework"))
			checkedD = BrokerRestriction.BR_RESTRICTION_DELETE.equals(currentBrokerRest.action)?"checked":"";
		%>
		<td align="center"><input   <%=checkedD%> type="checkbox" value="1" name="selectAllDeleteExp<%=i%>" class="selectIDDeleteExp" ></td>
		</tr>
		<%
		i++;
		}
	}	
}	
%>	
</tbody>
</table>
</tr>
</table>
</div>
</td>
<td class="tabletextwhite" width="-1%" nowrap="nowrap"></td>
</tr>
</table>

<!-- Add New Restriction position  -->

<BR/>
<table border=0 cellPadding=0 cellSpacing=0 width="100%">
<tr>
<td width="100%" height="20" class="tabletextwhite" bgcolor="#999999"><b>Add New Restriction(s)</b></td>
</tr>
</table>
<BR/>

<table border="1%" cellPadding=0 cellSpacing=0 align="center" width="95%">
<tr>
<td width="-1%" height="20" class="tabletextwhite" ></td>
<td width="100%" height="20" class="tabletextwhite" >

<div class="scrollNewRestriction" >
<table border=0 cellPadding=0 cellSpacing=0 width="100%">
<tr>
<tr>
<table cellSpacing=1 cellPadding=1 width="100%" bgColor=#ffffff border=0 id="brokerAddNewRowGenID">
	<tbody >
	<tr><br/>
			<th class="tabletextblack" align="left">General Rule(s)</th>
			<td></td>			
			<td></td>
			<td></td>
			<td></td>
			<td class="tabletextblack" ><IMG alt="AddBrokerRestriction" border="0" height="19" src="<%=LANG_ROOT%><%=newImages%>/b_add_y_ffcc66.gif" width=100 align="middle" style="cursor:pointer;" id='addGeneruleID'></td> 			
	</tr>
	<tr>
		<th bgcolor="#999999" class="tabletextwhite" width="4%">Eff Date</th>
		<th bgcolor="#999999" class="tabletextwhite" width="4%">End Date</th>
		<th bgcolor="#999999" class="tabletextwhite" width="3%">BD ID</th>
		<th bgcolor="#999999" class="tabletextwhite" width="3%">Restrict</th>
		<th bgcolor="#999999" class="tabletextwhite" width="6%">Product</th>
		<th bgcolor="#999999" class="tabletextwhite" width="2%"></th>
	</tr>
<%
if(genAddRest != null)
{
	for(int i=0; brRestGenStartmM != null && genAddRest!=null && i<genAddRest.length;i++)
	{
		
%>
	<tr id="trB1">
		<td align="center" width="1%">
			<INPUT  class=tabletextblack onkeydown=KeyDown(this,event); onkeyup=KeyPress(this,event); onfocus=gotFocus(this); maxLength=2 size=2 value="<%=brRestGenStartmM[i] %>" name="brRestGenStartMM<%=i%>"> /
			<INPUT  class=tabletextblack onkeydown=KeyDown(this,event); onkeyup=KeyPress(this,event); onfocus=gotFocus(this); maxLength=2 size=2 value="<%=brRestGenStartdD[i] %>" name="brRestGenStartDD<%=i%>"> /
			<INPUT  class=tabletextblack onkeydown=KeyDown(this,event); onkeyup=KeyPress(this,event); onfocus=gotFocus(this); maxLength=4 size=4 value="<%=brRestGenStartyY[i] %>" name="brRestGenStartYY<%=i%>">
			<A onclick="g_Calendar.show(this, BrokerRestrictionsForm.brRestGenStartMM<%=i%>, BrokerRestrictionsForm.brRestGenStartDD<%=i%>, BrokerRestrictionsForm.brRestGenStartYY<%=i%>)" href="javascript:void(0);">
			<IMG height=20 alt=Calendar src="<%=LANG_ROOT%><%=newImages%>/calendar_v02.gif" width=23 border=0> </A>
		</td>
		<td align="center" width="1%">
			<INPUT  class=tabletextblack onkeydown=KeyDown(this,event); onkeyup=KeyPress(this,event); onfocus=gotFocus(this); maxLength=2 size=2  value="<%= brRestGenEndmM[i] %>" name="brRestGenEndMM<%=i%>" > /
			<INPUT  class=tabletextblack onkeydown=KeyDown(this,event); onkeyup=KeyPress(this,event); onfocus=gotFocus(this); maxLength=2 size=2  value="<%= brRestGenEnddD[i] %>" name="brRestGenEndDD<%=i%>" > /
			<INPUT  class=tabletextblack onkeydown=KeyDown(this,event); onkeyup=KeyPress(this,event); onfocus=gotFocus(this); maxLength=4 size=4  value="<%= brRestGenEndyY[i] %>" name="brRestGenEndYY<%=i%>" >
			<A onclick="g_Calendar.show(this, BrokerRestrictionsForm.brRestGenEndMM<%=i%>, BrokerRestrictionsForm.brRestGenEndDD<%=i%>, BrokerRestrictionsForm.brRestGenEndYY<%=i%>)" href="javascript:void(0);">
			<IMG height=20 alt=Calendar src="<%=LANG_ROOT%><%=newImages%>/calendar_v02.gif" width=23 border=0> </A>
		</td>
		<td align="center" width="1%" >
		<INPUT    maxLength='7' size='13' name='generalBD' value='<%=defBrokerID+"(All Brokers)" %>' disabled style='font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 11px; width:150px; color: #000000; text-decoration: none;'>
		</td>
		<td align="center">
		<select   name="genRestrict" class="tabletextblack" >
			<option value="0">Yes</option>
			<option <%=(genAddRest[i].equals("1"))?"selected":""%> value="1">No</option>
		</select>
		</td>
		<td align="center" class=tabletextblack>
		<select    name="productNameAdNew" style='font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 11px; width:250px; color: #000000; text-decoration: none;' id='productNameAddID'>
		<option value=''>--Select Product--</option>
		<%
		if(productPlanList !=null)
		{
			String planCd = "";
			String planDesc = "";
			String selectedd = "";
			if("Fund".equalsIgnoreCase(brokerRestrictionSelect))
			{	
			for(int k=0; selectedProductName!=null && k<selectedProductName.length; k++)
			{
				selectedd = "";
				for( int m=0; m< productPlanList.size(); m++)
				{
					BrokerRestriction brd = productPlanList.get(m); 
					planCd = brd.planCode;
					planDesc = brd.desc;
					if(selectedProductName[k].equals(generalProductSelect[i]) && planCd.equals(generalProductSelect[i]))
					{
						selectedd = "selected";
						break;
					}
					if(planCd.equals(selectedProductName[k]))
						break;
				}
				if(!"".equals(planCd) && !"".equals(planDesc))
				{
					%>
					<option <%=selectedd%> value="<%=planCd%>"><%=planDesc%></option>
					<%
				}
			}
		}
		else if("Feature".equalsIgnoreCase(brokerRestrictionSelect))
		{	
			for( int m=0; m< productPlanList.size(); m++)
			{
				BrokerRestriction brd = productPlanList.get(m); 
				planCd = brd.planCode;
				planDesc = brd.desc;
				if(planCd.equals(productNameFeat))
				{
					if(generalProductSelect[i].equals(productNameFeat) && planCd.equals(productNameFeat))
						selectedd = "selected";
					%>
					<option <%=selectedd%> value="<%=planCd%>"><%=planDesc%></option>
					<%
				}
				
			}
		}
	}
	%>
		</select>
		</td>
		<td align="center"><a href="javascript:void(0);" id="addNewRestDelete" onclick="deleteBrokerRowGen(this);">Delete</a></td>
	</tr>
	<%} 
	}%>
	
	</tbody>
</table>
<table cellSpacing=1 cellPadding=1 width="100%" bgColor=#ffffff border=0 id ="brokerAddNewRowExpID">
	<tbody>
		<tr><br/>
			<th class="tabletextblack" align="left">Exceptional Rule(s)</th>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td class="tabletextblack" ><IMG alt="AddBrokerRestriction" id='addExceptionalID' border="0" height="19" src="<%=LANG_ROOT%><%=newImages%>/b_add_y_ffcc66.gif" width=100 align="middle" style="cursor:pointer;"></td>
		</tr>
		<tr>
			<th bgcolor="#999999" class="tabletextwhite" width="4%">Eff Date</th>
			<th bgcolor="#999999" class="tabletextwhite" width="4%">End Date</th>
			<th bgcolor="#999999" class="tabletextwhite" width="3%">BD ID</th>
			<th bgcolor="#999999" class="tabletextwhite" width="3%">Restrict</th>
			<th bgcolor="#999999" class="tabletextwhite" width="6%">Product</th>
			<th bgcolor="#999999" class="tabletextwhite" width="2%"></th>
		</tr>
		<%
		for(int i=0; bRStartExpmM!= null && expRestriction != null && i<expRestriction.length;i++)
		{	
		%>
		<tr id="trE1">
			<td align="center" width="1%">
			
			<INPUT   class=tabletextblack onkeydown=KeyDown(this,event); onkeyup=KeyPress(this,event); onfocus=gotFocus(this); maxLength=2 size=2 value="<%=bRStartExpmM[i] %>" name="bRStartExpMM<%=i%>"> /
			<INPUT   class=tabletextblack onkeydown=KeyDown(this,event); onkeyup=KeyPress(this,event); onfocus=gotFocus(this); maxLength=2 size=2 value="<%=bRStartExpdD[i] %>" name="bRStartExpDD<%=i%>"> /
			<INPUT   class=tabletextblack onkeydown=KeyDown(this,event); onkeyup=KeyPress(this,event); onfocus=gotFocus(this); maxLength=4 size=4 value="<%=bRStartExpyY[i] %>" name="bRStartExpYY<%=i%>">
		<A   onclick="g_Calendar.show(this, BrokerRestrictionsForm.bRStartExpMM<%=i%>, BrokerRestrictionsForm.bRStartExpDD<%=i%>, BrokerRestrictionsForm.bRStartExpYY<%=i%>)" href="javascript:void(0);">
		<IMG height=20 alt=Calendar src="<%=LANG_ROOT%><%=newImages%>/calendar_v02.gif" width=23 border=0> </A>
			</td>
			<td align="center" width="1%">
			<INPUT  class=tabletextblack onkeydown=KeyDown(this,event); onkeyup=KeyPress(this,event); onfocus=gotFocus(this); maxLength=2 size=2  value="<%=bREndExpmM[i] %>" name="bREndExpMM<%=i%>" > /
			<INPUT  class=tabletextblack onkeydown=KeyDown(this,event); onkeyup=KeyPress(this,event); onfocus=gotFocus(this); maxLength=2 size=2  value="<%=bREndExpdD[i] %>" name="bREndExpDD<%=i%>" > /
			<INPUT  class=tabletextblack onkeydown=KeyDown(this,event); onkeyup=KeyPress(this,event); onfocus=gotFocus(this); maxLength=4 size=4  value="<%=bREndExpyY[i] %>" name="bREndExpYY<%=i%>" >
			<A  onclick="g_Calendar.show(this, BrokerRestrictionsForm.bREndExpMM<%=i%>, BrokerRestrictionsForm.bREndExpDD<%=i%>, BrokerRestrictionsForm.bREndExpYY<%=i%>)" href="javascript:void(0);">
			<IMG  height=20 alt=Calendar src="<%=LANG_ROOT%><%=newImages%>/calendar_v02.gif" width=23 border=0> </A>
			</td>
			<td align="center" width="1%" >
			
			<select   id="target_brkr_dealer" name='exceptionalBD' class="generalBDVal" style='font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 11px; width:150px; color: #000000; text-decoration: none;'>
			<option value="0">--Selected Brokers--</option>
			<%	
			String selectedBr = "";
			if(brokerDealerMap != null)
			{
				for(int k=0; selectedToBdList!=null && k < selectedToBdList.length;k++)
				{	
					selectedBr = "";
					String toBrDetails =  brokerDealerMap.get(selectedToBdList[k]);
					if(expBDSelect[i].equals(selectedToBdList[k]))
					{
						selectedBr = "selected";
					}
					if(!"".equals(toBrDetails) && null != toBrDetails)
					{
						%>
						<option <%=selectedBr%> value="<%=selectedToBdList[k]%>"><%=toBrDetails%></option>	
						<%
					}
				}
			}
			%> 
			</select>
			</td>
			<td align="center" width="1%">
			<select   name="expRestrict" class="tabletextblack" >
				<option value="0">Yes</option>
				<option <%=(expRestriction[i].equals("1"))?"selected":""%> value="1">No</option>
			</select>
			</td>
			<td align="center" class=tabletextblack width="1%">
			<select  name="productNameExNew" class="tabletextblack" id='productNameExpAddID' style='font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 11px; width:250px; color: #000000; text-decoration: none;'>
			<option value=''>--Select Product--</option>
		  	 <%
		  	if(productPlanList !=null)
			{
				String planCd = "";
				String planDesc = "";
				String selectedd = "";
				if("Fund".equalsIgnoreCase(brokerRestrictionSelect))
				{	
				for(int k=0; selectedProductName!=null && k<selectedProductName.length; k++)
				{
					selectedd = "";
					for( int m=0; m< productPlanList.size(); m++)
					{
						BrokerRestriction brd = productPlanList.get(m); 
						planCd = brd.planCode;
						planDesc = brd.desc;
						if(selectedProductName[k].equals(expProductSelect[i]) && planCd.equals(expProductSelect[i]))
						{
							selectedd = "selected";
							break;
						}
						if(planCd.equals(selectedProductName[k]))
							break;
					}
					if(!"".equals(planCd) && !"".equals(planDesc))
					{
					%>
					<option <%=selectedd%> value="<%=planCd%>"><%=planDesc%></option>
					<%
					}
				}
				}
				else if("Feature".equalsIgnoreCase(brokerRestrictionSelect))
				{
					for( int m=0; m< productPlanList.size(); m++)
					{
						BrokerRestriction brd = productPlanList.get(m); 
						planCd = brd.planCode;
						planDesc = brd.desc;
						if(planCd.equals(productNameFeat))
						{
							if(expProductSelect[i].equals(productNameFeat) && planCd.equals(productNameFeat))
								selectedd = "selected";
							%>
							<option <%=selectedd%> value="<%=planCd%>"><%=planDesc%></option>
							<%
							
						}
					}
				}
			}
		  	 %>
		  	 </select>
			</td>
			<td align="center" width="1%"><a href="javascript:void(0);" id="expAddNewRestDelete" onclick="deleteBrokerRowExp(this);">Delete</a>
			</td>
			</tr>
			<% }  %>
		</tbody>
</table>
</tr>
</table>
</div>

</td>
<td class="tabletextwhite" width="-1%" nowrap="nowrap"></td>
</tr>
</table>

<table border=0 cellPadding=0 cellSpacing=0 width="100%" >
<tr>
<td></td>
<td></td>
<td></td>&nbsp;&nbsp;
<td class=tabletextblack align="right">View State Approval &nbsp;&nbsp;&nbsp;
<select   class=tabletextblack name="viewstatusApp" id='viewStateApproval' style="margin-right:50px; width:200px;">
<option value='0'>--Select Product--</option>
<%
	for(int k=0; productPlanList != null &&  k<productPlanList.size();k++)
	{
		BrokerRestriction brProducts = productPlanList.get(k);
		if((brProducts.planCode).equals("$$$"))
		{
			continue;
		}
%>
<option value='<%=brProducts.planCode%>'><%=brProducts.desc%></option>
<% 
	}
%>
</select>
</td>
</tr>
</table> 
<%
}
%>
 
 <input type="hidden" name="strImplDate" value=<%=systemDeploymentDate%>>
 <input type="hidden" name="subuser" value=<%=loginUser%>>
 <input type="hidden" name="codeid1" value=<%=codeID1%>>
 <input type="hidden" name="codeid2" value=<%=codeID2%>>
 <input type="hidden" name="fundorfeat" value=<%=brokerRestrictionSelect%>>
 <input type="hidden" name="prodfeat" value=<%=productNameFeat%>>
 <input type="hidden" name="prodFamily" value=<%=productFamily%>>
 <input type="hidden" name="prodFamily1" value=<%=productFamily1%>>
 <%-- <input type="hidden" name="fromBack" value=<%=fromBack.equals("rework")?"rework":""%>> --%>
 <input type="hidden" name="prevImplDt" value=<%=prevImplDt%>>
 <input type="hidden" name="prevsubBy" value=<%=prevsubBy%>>
 <input type="hidden" name="submittedon" value="<%=prevSubmittedDt%>">
 <input type="hidden" name="searchBrokerRest" value=<%=brokerRestrictionSelect%>>
 <input type="hidden" name="searchProdFamly" value=<%=productFamily%>>
 <input type="hidden" name="searchProdFamly1" value=<%=productFamily1%>>
 <input type="hidden" name="SearchfundOrFeature" value=<%=selectedFundOrFeat %>>
 <input type="hidden" name="searchFundFlg" value=<%=fundFlag%>> 
  
<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
<TBODY>
<TR>
<TD bgColor=#006699 width=40%><IMG height=30 alt="" src="<%=LANG_ROOT%><%=newImages%>/spacer.gif" width=1 border=0>
<TD class=tabletextblack bgColor=#006699 width="60%">
<td align="center" bgColor=#006699><a href="BrokerRestrictions.jsp"><img src="<%=LANG_ROOT%><%=newImages%>/b_main_menu.gif" alt="Main Menu" border="0" width="79" height="19" align="middle"></a> </td>
<td bgcolor="#006699" align="center" >
<a href="BrokerRestrictionVerify.jsp"><input type="image" name="Next" id="Next" value="BRSubmit" src="<%=LANG_ROOT%><%=newImages%>/b_next_o_ffffff.gif" width="79" height="19" align="middle" border="0" alt="Next"></a>
</td></TR>
</TBODY>
</TABLE>
</form>
</table>
<!--- End Footer -->
<%@include file="../include/copyright.inc"%>
</body>
</html>

　
　
　
