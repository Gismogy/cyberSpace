function listFunctions() {
	grep -E 'function [a-zA-Z0-9_]+\s*\(' $CS/core-config/functions/* | awk -F' ' '{print $2}'
}
