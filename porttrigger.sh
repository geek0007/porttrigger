#!/bin/sh

usage(){

 echo "port_trigger trig_rule_no trigger_port fwd_port"
 echo  "Example (port): port_trigger 1 6565 8585"
 echo  "Example (port range): port_trigger 2 6565-6570 8585-8590"
 echo  "Example (port range): port_trigger 2 6565-6570 8585"
 echo  "Example (port range): port_trigger 2 6565  8585-8590"

}

rule_no=${1}
trigger_port=${2}
fwd_port=${3}
trigger_port_low=0
trigger_port_high=0
trigger_port_detected=0
port_range=""

if [  "${rule_no}" == "" ] || [ "${trigger_port}" == "" ] || [ "${fwd_port}" ==
                                                             
 usage                                                       
 exit 1                                     
                                            
fi                                                           
                                                              
test_range=`echo "${trigger_port}" | grep -`                                   
if [ "${test_range}"  == "" ] ; then                                           
                                                                               
  port_range="port"                                                            
  trigger_port_low=${trigger_port}                                             
                                                                               
else             
                                                                              
  port_range="portrange"                                     
  trigger_port_low=`echo "${trigger_port}" | cut -d "-" -f 1`
  trigger_port_high=`echo "${trigger_port}" | cut -d "-" -f 2`
                                                              
fi                                                            
                                                              
PORT_TRIGGER="PORT_TRIGGER_${rule_no}"                                         
                                                                               
#forward_port $fw_port $ex_ip $in_ip                                           
forward_port(){                                                                
                                                                               
fwd_port2=`echo $1 | sed "s/-/:/g"`       

  echo iptables -N ${PORT_TRIGGER}                                             
  echo iptables -I INPUT -j ${PORT_TRIGGER}                                    
  echo iptables -t nat -N ${PORT_TRIGGER}                                      
  echo iptables -t nat -I PREROUTING -j ${PORT_TRIGGER}                        
  echo iptables -t nat -A ${PORT_TRIGGER} -p tcp -d ${2} --dport  ${fwd_port2} -
  echo iptables -t nat -A ${PORT_TRIGGER} -p udp -d ${2} --dport  ${fwd_port2} -
  echo iptables -A ${PORT_TRIGGER} -p tcp -d ${2} --dport ${fwd_port2} -j ACCEPT
  echo iptables -A ${PORT_TRIGGER} -p udp -d ${2} --dport ${fwd_port2} -j ACCEPT
                                                                                
   /bin/iptables -N ${PORT_TRIGGER}                                                   
   /bin/iptables -I INPUT -j ${PORT_TRIGGER}                        
   /bin/iptables -t nat -N ${PORT_TRIGGER}                                           
   /bin/iptables -t nat -I PREROUTING -j ${PORT_TRIGGER}                             
   /bin/iptables -t nat -A ${PORT_TRIGGER} -p tcp -d ${2} --dport  ${fwd_port2} -j DNA
   /bin/iptables -t nat -A ${PORT_TRIGGER} -p udp -d ${2} --dport  ${fwd_port2} -j DNA
   /bin/iptables -A ${PORT_TRIGGER} -p tcp -d ${2} --dport ${fwd_port2} -j ACCEPT     
   /bin/iptables -A ${PORT_TRIGGER} -p udp -d ${2} --dport ${fwd_port2} -j ACCEPT     
                                                                                
}       

while true                                                                      
do                                                                              
                                                                                
/sbin/tcpdump -n -c 2 -i br0 ${port_range} ${trigger_port} > /tmp/port_trigger_$
                                                                                
line=`sed '1q;d' /tmp/port_trigger_${rule_no}`                                  
internal_ip=`echo ${line} | cut -d '>' -f 1 | cut -d ' ' -f 3 | sed 's/\(.*\.\).
#external_ip=`echo ${line} | cut -d '>' -f 2 | cut -d ':' -f 1 | sed 's/\(.*\.\)
trigger_port_detected=`echo ${line} | cut -d '>' -f 2 | cut -d ':' -f 1 | cut -d
external_ip=` ifconfig eth2.4 | grep "inet addr" | cut -d ':' -f 2 | cut -d ' ' 
external_ip2=` ifconfig eth2.5 | grep "inet addr" | cut -d ':' -f 2 | cut -d ' '
external_ip3=` ifconfig eth3 | grep "inet addr" | cut -d ':' -f 2 | cut -d ' ' -
                                                                                
if [ "${port_range}" == "port" ] ; then                                         
                                                                                
  [ ${trigger_port_detected} -ne  ${trigger_port_low} ] && { sleep 1; continue; 
                                                                                
else                                                                            
                                                                                
  [ ${trigger_port_detected} -ge ${trigger_port_low} ] || [ ${trigger_port_detec
                                                                                
fi                          

if [ "${internal_ip}" != "0" ] ; then                                           
                                                                              
  [ "${external_ip}" != "" ] && forward_port ${fwd_port} ${external_ip} ${intern
  [ "${external_ip2}" != "" ] && forward_port ${fwd_port} ${external_ip2} ${inte
  [ "${external_ip3}" != "" ] && forward_port ${fwd_port} ${external_ip3} ${inte
                                                                                
  sleep 300                                                                     
                                                                                
  /bin/iptables -t filter -F ${PORT_TRIGGER}                                    
  /bin/iptables -t nat -F ${PORT_TRIGGER}                                       
                                                                  
 else                                                                            
                                                                                
  echo "not found"                                                              
  sleep 1                                                                       
                                                                                
fi                                                                              
                                                                                
done     
