<?
####################################################
// This file determins if the entered user information is valid or not
// Date Created: 11.19.08
// Version 1.0
// Revised 01.02.2009 - Changed Session Variables
####################################################
//ini_set( 'display_errors', true );
//error_reporting( E_ERROR ^ ~E_NOTICE );
include('core.php');
//include('includes/db_conn.php');

$email = t($_REQUEST['email']);
$email2 = strtolower(t($_REQUEST['email']));
$email3 = t($_REQUEST['email']); //used for ldap matching
$email4 = strtolower(t($_REQUEST['email'])); //used for ldap matching
$pass = str_replace("'","''",trim($_REQUEST['password']));
$dateToday = date('d-M-Y');
$go_url = t($_REQUEST['go_url']);
$keep_me=t($_REQUEST['keep_me_logged']);
$from_lis=false;
$username = trim($email2); //$_POST['username'];

if($keep_me=='remember_me' || $keep_me==1) {
	$series_id=md5(uniqid(mt_rand(), true));
	$token = md5(uniqid(mt_rand(), true));
}

$sql = "SELECT usr_custom_auth(:email, :pass) AS AUTH from dual";
$loginStmt = oci_parse($conn, $sql) or die('Custom Auth Fail');
oci_bind_by_name($loginStmt, ':email', $email);
oci_bind_by_name($loginStmt, ':pass', $pass);
oci_execute($loginStmt);
$loginRows = oci_fetch_all($loginStmt, $loginResults);

$auth = $loginResults['AUTH'][0];

if ($auth==0) { //trying lowercase
	$sql = "SELECT usr_custom_auth(:email, :pass) AS AUTH from dual";
	$loginStmt = oci_parse($conn, $sql) or die('Custom Auth Fail');
	oci_bind_by_name($loginStmt, ':email', $email2);
	oci_bind_by_name($loginStmt, ':pass', $pass);
	oci_execute($loginStmt);
	$loginRows = oci_fetch_all($loginStmt, $loginResults);
}
$auth = $loginResults['AUTH'][0];
if ($auth==0 && $pass!='' && strpos($email,'@')===false) { //trying ldap
    $adServer = "ldap://wshq-rdc04.wescodist.com:389";

    $ldap = ldap_connect($adServer);
    $username = trim(strtolower($email)); //$_POST['username'];
    $password = $pass; //$_POST['password'];

    $ldaprdn = 'wescohq' . "\\" . $username;

    ldap_set_option($ldap, LDAP_OPT_PROTOCOL_VERSION, 3);
    ldap_set_option($ldap, LDAP_OPT_REFERRALS, 0);
    if(trim($password)!='') {
        $bind = @ldap_bind($ldap, $ldaprdn, $password);
        //echo 'Bound: '.$bind;

        if ($bind)	{
            $filter="(sAMAccountName=$username)";
            $result = ldap_search($ldap,"DC=wescodist,DC=com",$filter);
            //$result = ldap_search($ldap,"OU=Liberty Cable,DC=wescodist,DC=com",$filter); //Removed Liberty to allow wesco users like Bob Hawks to access the hub
            ldap_sort($ldap,$result,"sn");
            $info = ldap_get_entries($ldap, $result);
            $ldap_dump = var_export($info,1);
            if(!isset($info['count']) || $info['count'] == 0) { // No match - could be an Anixter user that doesn't have a samaccountname
                $filter="(mailnickname=$username)"; // try mailnickname as the filter instead of samaccountname - they would be the same value
                $result = ldap_search($ldap,"DC=wescodist,DC=com",$filter);
                $info = ldap_get_entries($ldap, $result);
                $ldap_dump = var_export($info,1);
                logWebEvent('Anixter Login Attempt',$dateToday,'ANIXTR',$username,$ldap_dump.' '.$pass,getUserIP(),$conn);
            }
            //echo 'Count: '.$info["count"];
            for ($i=0; $i<$info["count"]; $i++)
            {
                if($info['count'] > 1)
                    break;
                if(isset($info[$i]["physicaldeliveryofficename"][0])) { //new accounts don't appear to have this attribute so need to check for it before setting it
                    $_SESSION['branch']=$info[$i]["physicaldeliveryofficename"][0];
                    $branch=$info[$i]["physicaldeliveryofficename"][0];
                } else {
                    $_SESSION['branch'] = 0; // No branch set
                    $branch = 0;
                }
                $email= isset($info[$i]["mail"][0]) ? $info[$i]["mail"][0] : $info[$i]["extensionattribute8"][0];
                $email2=isset($info[$i]["mail"][0]) ? strtolower($info[$i]["mail"][0]) : strtolower($info[$i]["extensionattribute8"][0]);// WXXXXXX usernames used for Anixter and Accu-tech use extensionattribute8 for email address
                if(strpos($email2,'@anixter.com')!==false || strpos($info[$i]['company'][0],'Anixter')!==false) { // this is an Anixter user - set some hard values

                    //$username = $username;//strtolower($info[$i]["mailnickname"][0]);
                    $_SESSION['branch'] = 9999; // Anixter branch in lweb_wesco_branches
                    $branch = 9999;
                } else if(strpos($email2,'@accu-tech.com')!==false || strpos($info[$i]['company'][0],'Accu-Tech')!==false) { // this is an Accu-Tech user - set some hard values

                    //$username = $username;//strtolower($info[$i]["mailnickname"][0]);
                    $_SESSION['branch'] = 8888; // Accu-Tech branch in lweb_wesco_branches
                    $branch = 8888;
                } else if(strpos($email2,'@wescodist.com')!==false) {
	                $email3=str_replace('@wescodist.com','@libav.com',$email);
	                $email4=strtolower(str_replace('@wescodist.com','@libav.com',$email2));
                }
	
	
	            //$branch='1971'; //for testing
                $auth = 1;
                //echo "<p>You are accessing <strong> ". $info[$i]["sn"][0] .", " . $info[$i]["givenname"][0] ."</strong><br /> (" . $info[$i]["samaccountname"][0] .")</p>\n";
                //echo "<p>Mail: ".strtolower($info[$i]["mail"][0])."</p>";
                //echo "<p>DN: ".strtolower($info[$i]["distinguishedname"][0])."</p>";
                //echo '<pre>';
                //var_dump($info);
                //echo '</pre>';
                $userDn = $info[$i]["distinguishedname"][0];
                $_SESSION['userDn']=$info[$i]["distinguishedname"][0];
                $individual_name=($info[$i]["givenname"][0]!='' ? $info[$i]["givenname"][0] .' '.$info[$i]["sn"][0] : ($info[$i]["cn"][0]!='' ? $info[$i]["cn"][0] : $info[$i]["name"][0]));
                $_SESSION['ldap_name']=str_replace("wescohq\\","",$ldaprdn);
                $_SESSION['ldap_chk']=$password;
				$ldap_name = str_replace("wescohq\\","",$ldaprdn);

            }
            @ldap_close($ldap);
            $event='LDAP Login';


        } else {
            logWebEvent('LDAP Bind Failure',$dateToday,'',$username,'LDAP Bind failed for '.$ldaprdn.chr(10).ldap_errno($ldap).' - '.ldap_error($ldap).chr(10).'Bad password or no network account (Anixter users all have email but only have a network account if they requested one) LDAP needs a samaccountname and valid password to bind properly',getUserIP(),$conn);
            //echo 'ldap-errno: '.ldap_errno($ldap);
            //echo 'ldap-error: '.ldap_error($ldap);

            //$msg = "Invalid email address / password";
            //echo $msg;
        }
    }
}
if ($auth==0) { //trying lis
    $sql = "SELECT 1 as auth  from lis.lis_users lu where lu.user_id = upper(:email) and lu.password=lis.lis_custom_hash(upper(:email), :pass)";
    $loginStmt = oci_parse($conn, $sql) or die('LIS login fail');
    oci_bind_by_name($loginStmt, ':email', $email);
    oci_bind_by_name($loginStmt, ':pass', $pass);
    oci_execute($loginStmt);
    $loginRows = oci_fetch_all($loginStmt, $loginResults);
    if($loginRows>0) {
        if ($loginResults['AUTH'][0] == 1) {
            $from_lis = true;
            $auth = 1;
        } else { $auth=0; }
    } else { $auth=0; }
    if($auth==0) {
	    logWebEvent('LIS Login failure',$dateToday,'',$username,'LIS Login failed for '.strtoupper($username).'. Bad password or not an LIS user (system can\'t distinguish between LDAP and LIS so it will try both if they both fail)',getUserIP(),$conn);
    }
}
if ($auth==0) { ///////// Trying WebBlox ///////////////////
    $sql = "SELECT 2 as auth from wbx.CQusers lu where lower(lu.userid) = lower(:email2) and lu.pass=:pass"; // using auth = 2 for WebBlox only
    $loginStmt = oci_parse($conn, $sql) or die('WebBlox login fail');
    oci_bind_by_name($loginStmt, ':email2', $email2);
    oci_bind_by_name($loginStmt, ':pass', $pass);
    oci_execute($loginStmt);
    $loginRows = oci_fetch_all($loginStmt, $loginResults);
    if($loginRows>0) {
        if ($loginResults['AUTH'][0] == 2) { // using auth = 2 for WebBlox only
            $from_webblox = true;
            $auth = 2;
        } else { $auth=0; }
    } else { $auth=0; }
}
//$auth = $loginResults['AUTH'][0];

if ($auth == 0)
{

	$auth_error = '<div id="notification_error">Your username or password are incorrect.</div>';
    if($_REQUEST['go_url']=='hub-login.php') {
        header('Location: hub-login.php?msg=Your Username or Password are Incorrect - be sure to use your WESCO username and current password (have you changed your WESCO password recently?)');
    } else {
        header('Location: login.php?msg=Your Username or Password are Incorrect.');
    }
	exit;
    		//echo $auth_error;
}
else {

    if ($from_webblox == true) { //this is a WebBlox user - need to use different query to get their info
        $uinfoSql = "SELECT lu.uname as individual_name
                    ,lu.userid as username
                    ,nvl(rc.cust_nbr,custcode) as rubicon_acc
                    ,lu.uemail as email
                    ,custcode webblox_acc
                    ,nvl(cust_nbr,'') cust_nbr
                    ,nvl(rc.name,company) name
                    ,nvl((select defmu from wbx.wbx_margins wm where wm.price_list=rc.price_list),defmu) defmu --get markup from margins table
                    , case when rc.cust_nbr is null
                        then 0
                        else 2
                    end permission
                    ,0 as logged --get a regular lweb_user account to be logged=1
                    ,1 as wblogged
                    , rs.name as tm_name
                    , rs.email_address as tm_email
                    , replace(rs2.name,'CST','Customer Support') as zm_name
                    , rs2.email_address as zm_email
                        FROM WBX.CQusers lu, rub.customers rc, WBX.DBO_CUST ls, rub.salespeople rs, rub.salespeople rs2
                        WHERE lu.uacct=rc.CUST_NBR(+)
                        and lu.custcode = ls.custid
                        and rc.salesman=rs.salesman_nbr(+)
                        and rc.salesman_2=rs2.salesman_nbr(+)
                        and (lower(lu.userid) = lower(:email2))";
        $uinfoStmt = oci_parse($conn, $uinfoSql) or die('WebBlox user load fail');
        oci_bind_by_name($uinfoStmt, ':email2', $email2);
        oci_execute($uinfoStmt);
        $uinfoRows = oci_fetch_all($uinfoStmt, $loginResults);


    } else if ($from_lis == true) { //this is an LIS user need to use different query to get their info
        $uinfoSql = "SELECT lu.username as individual_name,lu.user_id as username,rc.cust_nbr as rubicon_acc,lu.access_level,nvl(lu.user_email,lu.user_id) as email,rc.*,'2' as permission, rs.name as tm_name, rs.email_address as tm_email, replace(rs2.name,'CST','Customer Support') as zm_name, rs2.email_address as zm_email , ls.cust_nbr as lis, qp.po_nbr ,1 as logged,0 as wblogged
                    FROM lis.lis_users lu, rub.customers rc, lis.lis_sites ls, rub.salespeople rs, rub.salespeople rs2,lweb.LWEB_QO_POS qp
                    WHERE lu.lis_company_code=ls.lis_company_code 
                    and lu.site = ls.site
                    and rc.salesman=rs.salesman_nbr
                    and rc.salesman_2=rs2.salesman_nbr
                    and ls.cust_nbr=rc.cust_nbr 
                    and lu.username=qp.username(+)
                    and (upper(lu.user_id) = upper(:email))";
        $uinfoStmt = oci_parse($conn, $uinfoSql) or die('nope');
        oci_bind_by_name($uinfoStmt, ':email', $email);
        oci_execute($uinfoStmt);
        $uinfoRows = oci_fetch_all($uinfoStmt, $loginResults);
        if($uinfoRows>0) { $loginResults['PERMISSION'][0]=getLISPermission($loginResults['ACCESS_LEVEL'][0]); }
    } else {

        $uinfoSql = "SELECT lu.*,rc.*, rs.name as tm_name, rs.email_address as tm_email, replace(rs2.name,'CST','Customer Support') as zm_name, rs2.email_address as zm_email , ls.cust_nbr as lis, ca.active , qp.po_nbr ,1 as logged,0 as wblogged
                    FROM lweb_users lu, rub.customers rc, lis.lis_sites ls, rub.salespeople rs, rub.salespeople rs2, lweb.lweb_chat_accounts ca,lweb.LWEB_QO_POS qp
                    WHERE lu.rubicon_acc=rc.cust_nbr
                    and ca.cust_nbr(+) = rc.cust_nbr
                    and rc.salesman=rs.salesman_nbr
                    and rc.salesman_2=rs2.salesman_nbr
                    and ls.cust_nbr(+)=rc.cust_nbr 
                    and lu.username=qp.username(+)
                    and (lu.username = :email or lu.username = :email2 or lu.username = :email3 or lu.username = :email4 ";
        if($event=='LDAP Login') {
            $uinfoSql .= " or lu.ldap_name=lower(:ldapname)";
        }
        $uinfoSql .= ")";
        $uinfoStmt = oci_parse($conn, $uinfoSql) or die('nope');
        oci_bind_by_name($uinfoStmt, ':email', $email);
        oci_bind_by_name($uinfoStmt, ':email2', $email2);
        oci_bind_by_name($uinfoStmt, ':email3', $email3);
        oci_bind_by_name($uinfoStmt, ':email4', $email4);
        if($event=='LDAP Login') {
            oci_bind_by_name($uinfoStmt, ':ldapname', $username );
        }
        oci_execute($uinfoStmt);
        $uinfoRows = oci_fetch_all($uinfoStmt, $loginResults);
    }

    if($uinfoRows==0 && $userDn!='') { //authenticated but with no user account - this is a WESCO user

        //Lookup branch info to get Rubicon account
        $uinfoSql="SELECT lwb.cust_nbr as rubicon_acc,rc.*, rs.name as tm_name, rs.email_address as tm_email, replace(rs2.name,'CST','Customer Support') as zm_name, rs2.email_address as zm_email , ls.cust_nbr as lis ,1 as logged,0 as wblogged
				FROM rub.customers rc, lis.lis_sites ls, rub.salespeople rs, rub.salespeople rs2, lweb.lweb_wesco_branches lwb
				WHERE lwb.cust_nbr=rc.cust_nbr 
                and rc.salesman=rs.salesman_nbr
                and rc.salesman_2=rs2.salesman_nbr
          		and ls.cust_nbr(+)=rc.cust_nbr 
          		and (lwb.branch = :branch)";
        $uinfoStmt = oci_parse($conn, $uinfoSql) or die('nope');
        oci_bind_by_name($uinfoStmt, ':branch', $branch);
        oci_execute($uinfoStmt);
        $uinfoRows = oci_fetch_all($uinfoStmt, $loginResults);
        if($uinfoRows>0) {
            $loginResults['INDIVIDUAL_NAME'][0] = $individual_name;
            $loginResults['USERNAME'][0] = $username;
            $loginResults['EMAIL'][0] = $email2;
            $loginResults['PERMISSION'][0] = '2';
        } else { //no branch identified yet
            $auth_error = '<div id="notification_error">Greetings '.$individual_name.'. Unfortunately your branch is not yet set up in our system. Please contact webmaster@libav.com for more information.</div>';
            logWebEvent('WESCO Login Attempt',$dateToday,'WESCO?',$username,'No Branch Found'.chr(10).json_encode($result).chr(10).json_encode($info),getUserIP(),$conn);
            header('Location: login.php?msg=Greetings '.$individual_name.'. Unfortunately your branch is not yet set up in our system. Please contact webmaster@libav.com for more information.'.$branch.' - '.$uinfoRows);
            exit;
        }

    } else if($uinfoRows==0) { // no results were returned from user query
        // could be an lweb user who's account has been purged?
        logWebEvent('Account Error',$dateToday,$loginResults['RUBICON_ACC'][0],$email,'User: '.$email.' is associated with an invalid account',getUserIP(),$conn);
        $loginResults['RUBICON_ACC'][0] = 'BARBIN';
        $_SESSION['rubacc'] = $loginResults['RUBICON_ACC'][0];
        $logged = 0;
        $_SESSION['logged'] = 0;
        header('Location: login.php?msg=There is an issue with your account. Please contact Business Development at 800-530-8998 or businessdevelopment@libav.com');
        exit;
    }
    if($event=='LDAP Login') {
        logWebEvent('LDAP Login',$dateToday,$loginResults['RUBICON_ACC'][0],$username,'LDAP Log in: '.$loginResults['EMAIL'][0].chr(10).$ldap_dump,getUserIP(),$conn);
    }
	
	$_SESSION['logged'] = $loginResults['LOGGED'][0]; // 1 for regular users, 0 for WebBlox only
    $_SESSION['wblogged'] = $loginResults['WBLOGGED'][0]; // 0 for regular users, 1 for WebBlox only
	$_SESSION['INDIVIDUAL_NAME'] = $loginResults['INDIVIDUAL_NAME'][0];
	$_SESSION['username'] = $loginResults['USERNAME'][0];
	$_SESSION['userID'] = $loginResults['USERNAME'][0];
	$_SESSION['email'] = $loginResults['EMAIL'][0];
    $_SESSION['permission'] = $loginResults['PERMISSION'][0];
	$_SESSION['rubacc'] = $loginResults['RUBICON_ACC'][0]; // DBO_CUST.CUSTID if WebBlox only
	$_SESSION['original_rubacc'] = $loginResults['RUBICON_ACC'][0];
	$_SESSION['webblox_acc'] = $loginResults['WEBBLOX_ACC'][0]; // holds the WebBlox-only cust number if there isn't a rubicon account
	$_SESSION['webbacc'] = $loginResults['WEBBLOX_ACC'][0]; // this could end up a comma separated string for searching (happens in a loop below)
	$_SESSION['elite'] = $loginResults['USER_FIELD_3'][0];
	$_SESSION['distributor']=($loginResults['CUST_NBR'][0]=='' ? 'WBUSER' : ($loginResults['DEALER_DISTRIBUTOR'][0]=='' ? 'DEALER' : $loginResults['DEALER_DISTRIBUTOR'][0]));
	$_SESSION['adUsername'] = $email;
	$_SESSION['master_user'] = $loginResults['MASTER_USER'][0];
	$_SESSION['canadian'] = (in_array($loginResults['CUST_CATEGORY'][0],array('CAN001','CANCOM','CANCON','CANRES')) && CurrencySymbol($_SESSION['rubacc'],$conn)!='CAD <sup>$</sup>*'? true : false);
    $_SESSION['xchg_code'] = $loginResults['XCHG_CODE'][0];
	$_SESSION['orig_acct'] = $loginResults['RUBICON_ACC'][0];
	$_SESSION['LIS'] = ($loginResults['LIS'][0]==''? 0 : 1);
    $_SESSION['inside_sales'] = $loginResults['ZM_NAME'][0];
    $_SESSION['salesman'] = $loginResults['SALESMAN'][0];
    $_SESSION['chat'] = $loginResults['ACTIVE'][0];
    $_SESSION['salesman_2'] = $loginResults['SALESMAN_2'][0];
    $_SESSION['po_nbr'] = strtoupper($loginResults['PO_NBR'][0]);
	unset($_SESSION['mylib_user']);
	if($loginResults['ACCESS_LEVEL'][0]!="") {
		$_SESSION['mylib_user'] = $loginResults['ACCESS_LEVEL'][0];
	}
	if($loginResults['PERMISSION'][0]>4) {
		$Sql = "SELECT salesman_nbr as rep_code FROM rub.salespeople WHERE email_address = '$email'";
			$Stmt = oci_parse($conn, $Sql) or die('nope');
			oci_execute($Stmt);
			$repRows = oci_fetch_all($Stmt, $repResults);
		if($repRows==0) {
			$Sql = "SELECT tm_code as rep_code FROM lweb.lweb_web_tm_localities WHERE tm_email = '$email'";
			$Stmt = oci_parse($conn, $Sql) or die('nope');
			oci_execute($Stmt);
			$repRows = oci_fetch_all($Stmt, $repResults);
		}
		if($repRows==0) {
			$Sql = "SELECT ism_code as rep_code FROM lweb.lweb_assoc_tm WHERE email = '$email'";
			$Stmt = oci_parse($conn, $Sql) or die('nope');
			oci_execute($Stmt);
			$repRows = oci_fetch_all($Stmt, $repResults);
		}
		if($repRows==0) {
			$Sql = "SELECT rep_code as rep_code FROM lweb.lweb_mr_tm WHERE (email = '$email' or rubacc='".$loginResults['RUBICON_ACC'][0]."') and not rep_code='---'";
			$Stmt = oci_parse($conn, $Sql) or die('nope');
			oci_execute($Stmt);
			$repRows = oci_fetch_all($Stmt, $repResults);
		}
		if($repRows>0) {
			for($i=0;$i<$repRows;$i++) {
				if($i>0) { $rep_code .= ","; }
				$rep_code .= "'".$repResults['REP_CODE'][$i]."'";
			}
			$_SESSION['rep_code'] = $rep_code;
		}
	}
	
	$_SESSION['currsymbol']=CurrencySymbol($_SESSION['rubacc'],$conn);
		
				 
	setcookie('cUsername', $email, time()+31536000);
	setcookie('adUsername', $email, time()+60*60*24*7,'/');
	setcookie('session', 'true', time()+28800);
    setcookie('srep', $_SESSION['salesman'], time()+31536000);
	if($series_id!='') {
		setcookie('login[user]', ($username!=''?$username:$email), time()+60*60*24*14);
		setcookie('login[series]', $series_id, time()+60*60*24*14);
		setcookie('login[token]', $token, time()+60*60*24*14);
		
		$sql="insert into lweb.lweb_users_persist(username,series,token) values ('$email','$series_id','$token')";
			
			$stmt = oci_parse($conn, $sql);
			$exec = oci_execute($stmt);
			oci_commit($conn);
	}
	
	$sql = "select distinct(ecommerce) 
		FROM rub.inv_item_master
		WHERE item_nbr like '%-WQ%'
		  and not item_nbr like 'BARBIN-WQ%'
		  and not ECOMMERCE = 'BARBIN'
		  and (ecommerce = '".$_SESSION['rubacc']."' ";
		if ($_SESSION['webbacc'] != "") {
			$sql .= " or ecommerce='".$_SESSION['webbacc']."'";
		}
		$sql .= ") AND prod_line_name <> 'DELETE'
		
		UNION
		
		select linked as ecommerce from wbx.related_accounts where master_acct='".$_SESSION['rubacc']."'
		
		union
		
		select master_cust as ecommerce from rub.customers where cust_nbr='".$_SESSION['rubacc']."' and master_cust is not null";
        
		
		
		$stmt = oci_parse($conn, $sql) or die('nope');
		oci_execute($stmt);
		$nrows = oci_fetch_all($stmt, $results);
		
		if ($nrows != 0) {
			$_SESSION['WBUSER'] = 1;

            for($z=0;$z<$nrows;$z++) {
                if($curr_ecomm!=$results['ECOMMERCE'][$z] && $results['ECOMMERCE'][$z]!=$_SESSION['rubacc'] && $results['ECOMMERCE'][$z]!='' && $results['ECOMMERCE'][$z]!='BARBIN') {
                    $curr_ecomm=$results['ECOMMERCE'][$z];
                    if($_SESSION['webbacc']=='') {
                        $_SESSION['webbacc']="".$results['ECOMMERCE'][$z]."";
                    } else {
                        $_SESSION['webbacc'].="','".$results['ECOMMERCE'][$z]."";
                    }
                }

            }
		}

	if (!$_COOKIE['isLibertyCus'])
	{
	
		setcookie('isLibertyCus', '1', time()+31536000);
		
	}
	else
	{
	
		$_COOKIE['isLibertyCus'] = 1;
		
	}
	
	$_SESSION['loggedId'] = logUserTime('',$_SESSION['sessID'],($username?$username:$email2),strtoupper(date('j-M-Y g.i.s.u A')),'login',$loginResults['RUBICON_ACC'][0]);
	if(strpos($email,'@lib')===false || $_SESSION['wblogged']==1) { // don't post for for liberty users
		//Process a new form submission in HubSpot in order to create a new Contact.
    
		$hubspotutk = $_COOKIE['hubspotutk'];  //grab the cookie from the visitors browser.
		$ip_addr = $_SERVER['REMOTE_ADDR'];  //IP address too.
		$hs_context = array(
				'hutk' => $hubspotutk,
				'ipAddress' => $ip_addr,
				'pageUrl' => $_SERVER['HTTP_REFERER'],
				'pageName' => 'Login'
			);
		$hs_context_json = json_encode($hs_context);
		
		//Need to populate these varilables with values from the form.
		$str_post = "email=" . urlencode($email)
				. "&territory_mgr=" . urlencode($loginResults['TM_NAME'][0])
				. "&tm_email=" . urlencode($loginResults['TM_EMAIL'][0])
				. "&zone_mgr=" . urlencode($loginResults['ZM_NAME'][0])
				. "&zm_email=" . urlencode($loginResults['ZM_EMAIL'][0])
				. "&hs_context=" . urlencode($hs_context_json);  //Leave this one be :)
		
		 //replace the values in this URL with your portal ID and your form GUID
		$endpoint = 'https://forms.hubspot.com/uploads/form/v2/427311/02ddff38-2a9d-47e2-a241-246e0d0d3fb9';
		
		$ch = @curl_init();
		@curl_setopt($ch, CURLOPT_POST, true);
		@curl_setopt($ch, CURLOPT_POSTFIELDS, $str_post);
		@curl_setopt($ch, CURLOPT_URL, $endpoint);
		@curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-Type: application/x-www-form-urlencoded'));
		@curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
		$response = @curl_exec($ch);  //Log the response from HubSpot as needed.
		$status_code = @curl_getinfo($ch, CURLINFO_HTTP_CODE); //Log the response status code
		@curl_close($ch);
		//echo $status_code . " " . $response;
		//exit;
	}
	//logWebEvent('User Login', $dateToday, $loginResults['RUBICON_ACC'][0], $loginResults['EMAIL'][0], $loginResults['RUBICON_ACC'][0] .' has logged in', gethostbyname($_SERVER['REMOTE_ADDR']),  $conn);

    if($_SESSION['wblogged']==1) { // WebBlox Only user - Redirect to WebBlox straight away (say that with a British accent 'cause it's funner)
        header('Location: /webblox');//header('Location: index.php');
        //header('Location: index.php');
        exit;
    } else if (!$go_url)
	{
	
		header('Location: index.php');
		exit;
		
	}
	else
	{
	    if((strpos($go_url,'login.php')!==false && strpos($go_url,'hub-login.php')===false) || strpos($go_url,'reg_')!==false || strpos($go_url,'cus_forgot_password.php')!==false || strpos($go_url,'cus_reset_password.php')!==false || strpos($go_url,'confirmation.php')!==false) {
			header('Location: index.php');//header('Location: index.php');
			//header('Location: index.php');
			exit;
			
		} else {
			unset($_SESSION['URL']);
			header('Location: ' . str_replace("?logout=true","",urldecode($go_url)));
			//header('Location: ' . str_replace("?logout=true","",urldecode($go_url)));
			exit;
			
		}
		
	}
	
	exit;
}

?>