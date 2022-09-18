# Variable declaration
## typeset
Declare a local variable (useful for functions) and you can set some rules of datatype/format to store values.

### Store in lowercase
```bash
typeset -l varLower="Hey Jude"
echo $varLower
hey jude
```

### Store in uppercase
```bash
typeset -u varUpper="Hey Jude"
echo $varUpper
HEY JUDE
```

### Store in integer (explicit declaration)
It seems more efficient for arithmetic tasks
```bash
typeset -i varInteger=42
echo $varInteger
42

typeset -i varInteger="Hey Jude"
Hey Jude: bad number
```

### Store in float (explicit declaration) /!\ Work in ksh93, maybe other shell?
It seems more efficient for arithmetic tasks
```bash
typeset -F3 varFloat=3.141
echo $varFloat
3.141

typeset -i varFloat="Hey Jude"
Hey Jude: bad number
```

# Substition variables
There are 4 possibilities:
1. ${var:-defaultVal}
* If $var is not empty, return this value
* If $var is empty, return "defaultVal"
```bash
var="Hey Jude"

echo $var
Hey Jude
echo ${var:-defaultVal}
Hey Jude
echo $var
Hey Jude

unset var

echo $var

echo ${var:-defaultVal}
defaultVal
echo $var

```

2. ${var:=defaultVal}
* If $var is not empty, return this value
* If $var is empty, set "defaultVal" to $var
```bash
var="Hey Jude"

echo $var
Hey Jude
echo ${var:=defaultVal}
Hey Jude
echo $var
Hey Jude

unset var

echo $var

echo ${var:=defaultVal}
defaultVal
echo $var
defaultVal
```

3. ${var:+defaultVal}
* If $var is not empty, return "defaultVal"
* If $var is empty, return value of $var (empty value)
```bash
var="Hey Jude"

echo $var
Hey Jude
echo ${var:+defaultVal}
defaultVal
echo $var
Hey Jude

unset var

echo $var

echo ${var:+defaultVal}

echo $var

```

4. ${var:?"variable is empty"}
* If $var is not empty, return this value
* If $var is empty, return variable name + message
```bash
var="Hey Jude"

echo $var
Hey Jude
echo ${var:?"variable is empty"}
Hey Jude
echo $var
Hey Jude

unset var

echo $var

echo ${var:?"variable is empty"}
var: variable is empty
echo $var

```

These substitions are very useful to simplify your source code in some case and you use native internal mechanisms of your shell :-)

Example 1:
```bash
# With substition
var=""

echo ${var:-defaultVal}
defaultVal

# Without substition
var=""

if [ -z "$var" ]; then
	echo "defaultVal"
else
	echo "$var"
fi
```

Example 2:
```bash
# With substition
var=""

${var:=defaultVal}

echo "$var"
defaultVal

# Without substition
var=""

if [ -z "$var" ]; then
	var="defaultVal"
fi

echo "$var"
defaultVal
```

## Length of value
```bash
var="Hey Jude"
echo ${#var}
8
```

## Substring
```bash
var="Hey Jude"
echo ${var:0:3}
Hey

echo ${var::3}
Hey
```

## Remove n fisrt characters
4 firsts characters:
```bash
var="Hey Jude"
echo ${var:4}
Jude
```

## Remove n last characters
5 lasts characters (5x ?):
```bash
var="Hey Jude"
echo ${var%?????}
Hey
```

# Redirections
## < Standard input
```bash
cat < /var/log/result.log
```

## << Heredoc
```bash
grep "Hey" << EOF
Hey
Jude
EOF
```

This syntax can avoid a pipe. Example:
```bash
echo "Hey
Jude" | grep "Hey"
```

## << Herestring
```bash
grep "Hey" <<< "Hey Jude"
```

This syntax can avoid a pipe. Example:
```bash
echo "Hey Jude" | grep "Hey"
```

# Few commands and/or parameters little known to avoid some pipe
## How to generate a sequence number?
```bash
seq 1 3
1
2
3

seq 0 2 10
0
2
4
6
8
10
```

## How to convert sizes <=> human readable?
```bash
numfmt --to=iec 1 1024 1048576
1
1,0K
1,0M

numfmt --to=iec --suffix=B 1 1024 1048576
1B
1,0KB
1,0MB

numfmt --from=iec --to=iec <<<"1024M"
1,0G

numfmt --from=iec --to=none <<<"1K"
1024

numfmt --from=iec --to=none <<<"1M"
1048576
```

For more details use manpage.

## Why do you write cat ... | grep ...?
* In some scripts I see:
```bash
cat /var/log/result.log | grep "error"
```
* Grep take in standard input a file and the best solution is:
```bash
grep "error" /var/log/result.log
```

## Number of occurences of grep result (number of line)
* Popular solution is:
```bash
grep "error" /var/log/result.log | wc -l
```
* Best solution:
```bash
grep -c "error" /var/log/result.log
```

## Sort and uniq
* Popular solution is:
```bash
cat /var/log/result.log | sort | uniq
```
* Best solution:
```bash
cat /var/log/result.log | sort -u
```

/!\ uniq command does not have a sort in date of 2022-09-18

## I need to perform a grep with some patterns
* In some scripts I see:
```bash
grep -v "info" /var/log/result.log | grep -v "debug"
```
* In regex you can with conditions:
```bash
grep -v "info\|debug" /var/log/result.log
```

You can avoid escape of | (\|) with grep parameter -E
```bash
grep -vE "info|debug" /var/log/result.log
```
