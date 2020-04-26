#!/bin/bash

##### Authors: Emon Sahariar and Sammay Sarker #####



function esam () {

    hostnm=HOSTNAMEHERE
    usnm=USERNAME
    rootpass=YOURROOTPASSWORD
    Nrootpass=YOURNONROOTPASSWORDHERE
    continent=YOURCONTINENT #e.g. Asia
    city=YOURCITYNAME #e.g Dhaka
    language=SECONDARYLOCALESCODE #e.g. bn_BD
    #mccode=intel-ucode # <-- uncomment, if you need intel microcode
    
    #denv=( konsole dolphin apper plasma )
    #denv=(gnome )
    #denv=(xfce4)
    #denv=(mate)
    # ^^ uncomment one, as your chosen desktop environment
    
    #wdriver=(  broadcom-wl-dkms ) # <-- uncomment, if you need broadcom driver
    bsrc=/.bashrc
    function help () {
	cat << EOF
esam : Error occured !
		 After fix mentioned error, run "esam" again. 
		 It will automatically resume the automation.
	   
                 Usage: esam [OPTION] or: esam-repeat
                 --from-JOBNAME run all functions, starting at JOBNAME
	         --only-JOBNAME run JOBNAME only, skipping others
                 Without OPTION parameter all functions run from the first.
                 Or, as indicated by the STATE variable.

	         To manually resume automation from a specific part, follow this-
		      from a run "esam --from-a"
	   	      from b run "esam --from-b"
	  
	         if you want to run automation from beginning again-
	  	      run "esam-repeat"
	 
	         To run a specific part and skip others, follow this-
 	  	      "esam --only-a" #for the part a.
	   	      "esam --only-b" #for the part b.
EOF

}

    ########## the main functions ##########
  
    
    function locwr() { 
cat >> /etc/locale.gen << EOF
en_US.UTF-8 UTF-8
$language UTF-8
EOF
    }

    function account () {
	    groupadd $usnm &&
	    useradd -s /bin/bash -g $usnm -m -k /dev/null $usnm &&
	    passwd $usnm <<< $(echo $Nrootpass && echo $Nrootpass) &&
	    usermod -aG wheel $usnm &&
	    echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers

	}
	

    function hst() {
	    cat > /etc/hosts << EOF
127.0.0.1	localhost.localdomain	localhost
::1		localhost.localdomain	localhost
127.0.1.1	$hostnm.localdomain	$hostnm
EOF
}


    function pacs() {

	pacman -S --noconfirm  dialog  xorg xorg-xinit  xterm sudo  iw linux-headers sddm emacs wpa_supplicant $mccode ${wdriver[*]} ${denv[*]}
	
	return
	
	}
	
    function TimeZone () {
	    echo '<<<<esam-progress>>>> --> (1/8) Adjusting time zone...'
    
	    ln -sf /usr/share/zoneinfo/$continent/$city /etc/localtime &&
	    hwclock --systohc

	return
    }

    function LanguageLocals () {
	echo -e '\n<<<<esam-progress>>>> --> (2/8) Setting language & localization..'
	locwr && locale-gen &&
	echo 'LANG=en_US.UTF-8' > /etc/locale.conf
	    

	return
    }

    function Hostname () {
	echo -e '\n<<<<esam-progress>>>> --> (3/8) Setting Hostname configurations...'
	echo "$hostnm" > /etc/hostname && hst

	return
    }

    function RootPass () {
	echo -e '\n<<<<esam-progress>>>> --> (4/8) Now Setting a root password...'
	passwd <<< $(echo $rootpass && echo $rootpass)
	

	return
    }

    function NonRootAccount () {
	echo -e '\n<<<<esam-progress>>>> --> (5/8) Setting  a non-root account...'
	account
	
	return
    }

    function DeToAccessories () {
	echo -e '\n<<<<esam-progress>>>> --> (6/8) installing DE(s), Xorg and useful Accesories...'
	pacs
	return
    }

    function SddmNetwork () {
	echo -e '\n<<<<esam-progress>>>> --> (7/8) Enabling sddm, network interface  during boot...'
	systemctl enable sddm.service &&
	systemctl enable NetworkManager.service
	     
	return
    }

    function Bashrc() {
	echo -e '\n<<<<esam-progress>>>> --> (8/8) Placing a bashrc in home...'
    cp $bsrc /home/$usnm/

	return
    }    

    
    ############ function runner ###########
    export STATE=${STATE:-0} # marks which completed functions
    local fn_list=(TimeZone LanguageLocals  Hostname RootPass NonRootAccount DeToAccessories SddmNetwork Bashrc) # list of functions; manually collated
    local fn_len=${#fn_list[@]} # number of functions in $fn_list


    
    # run functions in range $fn_list[$start:$stop[
    function esam_runner () {
	#That means if $1 and $2 exists then the default values
	# will be retrieved from 1st commmand line Argument and 2nd command
	#line argument respectively.
	local start=${1:-$STATE}
	local stop=${2:-$fn_len}
	
	while [ $start -lt $stop ]; do
	    echo "Numer Of Job Done  $start"
	    echo "Job To Done Altogether $stop"
	    
	    #Report each time, whether the running function is successful or not.				
	    # loop thru functions (catch errors w if-else)							
	    if [ "$op_mode" != "only" ]; then									
	    	if "${fn_list[$start]}"; then 									
	    	    echo -e "DOING ${fn_list[$start]}: JOB SUCCESSFUL.\n"					
	    	    start=$((start+1)) && export STATE=$((STATE+1))						
	    	    												
	    	else												
	    	    echo "DOING ${fn_list[$start]}: JOB FAILED. PLEASE FIX THE ${fn_list[$start]} !"		
	    	    help >& 2											
	    	    break											
	    	    return 1											
	    	fi												
	    													
	    else #to achieve the --only-* functions								
	    	if "${fn_list[$start]}"; then # loop thru functions (catch errors w if-else)			
	    	    echo -e "DOING ${fn_list[$start]}: JOB SUCCESSFUL.\n"					
	    	    break											
	    	else												
	    	    echo "DOING ${fn_list[$start]}: JOB FAILED. PLEASE FIX THE ${fn_list[$start]} !"		
	    	    help >& 2											
	    	    break											
	    	    return 1											
	    	fi												
	    fi												
	    
		
	done
	
    }


    
    ############ esam bootstrap ############
    # recognize args in the form: --from-*, --only-*
    if [[ $1 =~ ^\-\-(only|from)\-(.*) ]]; then
	local op_mode=${BASH_REMATCH[1]} # capture group 1; operation mode. As BASH_REMATCH always stores matched regex word.
	local fn_name=${BASH_REMATCH[2]} # capture group 2; function name

	#echo ${BASH_REMATCH[1]}
	#echo ${BASH_REMATCH[2]}
	# find index of $fn_name in $fn_list
	local index
	for i in "${!fn_list[@]}"; do
	    [ "${fn_list[$i]}" == "$fn_name" ] && index=$i && break
		
	done

	
	# ($index remains unset if no function index found)
	[ -z $index ] && echo -e "bad JOB name given.\n" && return
	
	
	# arg is --from-*; or --only-* loop from given function till end

	
	if [[ $op_mode == "from" || $op_mode == "only" ]]; then	
	    esam_runner $index					
	fi								
	
	
	# arg is not recognized; show help and quit
    elif [ $1 ]; then
	echo -e "$1 is not a valid parameter.Bad parameter(s) given.\n"
	help >& 2
	return 1

	
	# no args, default operation; start loop from $STATE
    else
	[ $STATE -ge $fn_len ] && echo -e "all done already. want to do it again? run "esam-repeat".\n" && return
	    esam_runner $STATE
	
    fi

}


function esam-repeat () {
    export STATE=0
    esam "$@"
}
