#!/bin/sh
# file: scripts/upgradep.sh

# ====================================================================
# host symbols;
# --------------------------------------------------------------------

. ${SCRIPTS}/hardware.sh
. ${SCRIPTS}/firmware.sh

# ====================================================================
# confirm connection;
# --------------------------------------------------------------------

echo -n "Interface [${ETH}]: "; read  
if [ ! -z ${REPLY} ]; then
	ETH=${REPLY}
fi

# ====================================================================
# check connection;
# --------------------------------------------------------------------

int6kwait -xqsi ${ETH} 
if [ ${?} != 0 ]; then
	echo "Device is not connected"
	exit 1
fi

# ====================================================================
# file symbols;
# --------------------------------------------------------------------

MAC=$(int6kid -Ai ${ETH})
DAK=$(int6kid -Di ${ETH})
NMK=$(int6kid -Mi ${ETH})

# ====================================================================
# confirm MAC;
# --------------------------------------------------------------------

echo -n "MAC [${MAC}]: "; read
if [ ! -z ${REPLY} ]; then
 	MAC="${REPLY}"                  
fi

echo -n "DAK [${DAK}]: "; read
if [ ! -z ${REPLY} ]; then
 	DAK="${REPLY}"                  
fi

echo -n "NMK [${NMK}]: "; read
if [ ! -z ${REPLY} ]; then
 	NMK="${REPLY}"                  
fi

# ====================================================================
# 
# --------------------------------------------------------------------

modpib -M ${MAC} -D ${DAK} -N ${NMK} ${PIB}  
if [ ${?} != 0 ]; then
	exit 1
fi

# ====================================================================
# 
# --------------------------------------------------------------------

# flash PIB only
# int6kp -i ${ETH} -P ${PIB} -D ${DAK} -C2


# flash FW and PIB
int6kp -i ${ETH} -P ${PIB} -N ${NVM} -D ${DAK} -F

if [ ${?} != 0 ]; then
	exit 1
fi

# ====================================================================
#  
# --------------------------------------------------------------------

int6k -i ${ETH} -I

# ====================================================================
#  
# --------------------------------------------------------------------

exit 0

