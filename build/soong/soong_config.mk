# Insert new variables inside the Cardinal structure
cardinal_soong:
	$(hide) mkdir -p $(dir $@)
	$(hide) (\
	echo '{'; \
	echo '"Cardinal": {'; \
	echo '    "Battery_real_time_info": $(if $(filter true,$(BATTERY_REAL_TIME_INFO)),true,false),'; \
	echo '    "Needs_text_relocations": $(if $(filter true,$(TARGET_NEEDS_PLATFORM_TEXT_RELOCATIONS)),true,false)'; \
	echo '},'; \
	echo '') > $(SOONG_VARIABLES_TMP)
