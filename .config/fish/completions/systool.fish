complete -c systool -s a -d "Show attributes of the requested resource"
complete -c systool -s b -d "Show information for a specific bus" -x
complete -c systool -s c -d "Show information for a specific class" -x
complete -c systool -s d -d "Show only devices"
complete -c systool -s h -d "Show usage"
complete -c systool -s m -d "Show information for a specific module" -x -a "(__fish_print_modules)"
complete -c systool -s p -d "Show absolute sysfs path to the resource"
complete -c systool -s v -d "Show all attributes with values"
complete -c systool -s A -d "Show attribute value for the requested resource" -x
complete -c systool -s D -d "Show only drivers"
complete -c systool -s P -d "Show device's parent"
