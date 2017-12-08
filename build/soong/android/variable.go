package android
type Product_variables struct {
	Needs_text_relocations struct {
		Cppflags []string
	}
	Battery_real_time_info struct {
		Cppflags []string
	}
}

type ProductVariables struct {
	Needs_text_relocations  *bool `json:",omitempty"`
	Battery_real_time_info  *bool `json:",omitempty"`	
}
