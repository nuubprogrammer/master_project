### Define gene ontology terms and find related genes 
# Silje Wilhelmsen

# Load libraries
library(AnnotationDbi)
library(org.Hs.eg.db)

# Define GO processes
define_go_process <- list(
  glycolysis = "GO:0006096",
  pdh = "GO:0045254",
  fao = "GO:0019395",
  tca = "GO:0006099",
  etc = "GO:0022900",
  chylomicron_clearance = "GO:0034382", 
  atp_synthesis = "GO:0042775",
  etc_succinate_to_ubiquinone = "GO:0006121",
  uncoupling_proteins = "GO:0017077",
  fatty_acid_transport = "GO:0015908",
  b_oxidation = "GO:0006635",
  monosaccharide_transmembrane_transport = "GO:1905950", 
  glucose_transmembrane_transport = "GO:1904659",
  protein_transmembrane_transport = "GO:0071806",
  dna_binding_transcription_factor_activity = "GO:0003700",
  translation_regulatory_activity = "GO:0045182",
  ketone_metabolic_process = "GO:0042180",
  hydroxybutyrate_dehydrogenase_activity = "GO:0003858",
  regulation_of_ketone_metabolic_process = "GO:0010565",
  ketone_catabolism = "GO:0046952",
  cardiac_muscle_contraction = "GO:0060048",
  negative_regulation_of_cardiac_muscle_contraction = "GO:0055118",
  positive_regulation_of_cardiac_muscle_contraction = "GO:0060452",
  calcium_mediated_signaling = "GO:0019722",
  regulation_of_cardiac_calcium_signaling = "GO:0010882",
  cardiac_muscle_tissue_growth = "GO:0055017",
  dna_binding_transcription_factor_activity = "GO:0003700", 
  dna_binding_transcription_activator_activity = "GO:0001216",
  dna_binding_transcription_factor_activity_rna_polymeraseII_specific = "GO:0000981",
  dna_binding_transcription_repressor_activity = "GO:0001217",
  ligand_modulated_transcription_factor_activity = "GO:0098531",
  transporter_activity = "GO:0005215",
  lipid_transporter_activity = "GO:0005319",
  protein_transporter_activity = "GO:0140318",
  transmembrane_transporter_activity = "GO:0022857",
  negative_regulation_of_creb_transcription_factor_activity = "GO:0032792",
  positive_regulation_of_creb_transcription_factor_activity = "GO:0032793",
  negative_regulation_of_nf_kappab_transcription_factor_activity = "GO:0032088",
  positive_regulation_of_nf_kappab_transcription_factor_activity = "GO:0051092",
  nf_kappab_complex = "GO:0071159",
  peroxisome_proliferator_activated_receptor_binding = "GO:0042975",
  transcription_coregulator_activity = "GO:0003712",
  transcription_coactivator_activity = "GO:0003713",
  transcription_corepressor_activity = "GO:0003714"
)

# Function to retrieve genes for a GO term
get_genes_for_go_process <- function(go_term) {
  entrez_ids <- AnnotationDbi::select(org.Hs.eg.db, 
                                      keys = go_term, 
                                      keytype = "GOALL", 
                                      columns = "ENTREZID")[, "ENTREZID"]
  
  gene_symbols <- AnnotationDbi::select(org.Hs.eg.db, 
                                        keys = entrez_ids, 
                                        keytype = "ENTREZID", 
                                        columns = "SYMBOL")[, "SYMBOL"]
  
  # Normalize gene symbols
  gene_symbols_upper <- toupper(gene_symbols)
  
  # Return unique gene symbols related to the GO term
  unique(gene_symbols_upper)
}

# Function to retrieve genes organized by process
get_genes_of_interest <- function(go_terms, define_go_process, get_genes_for_go_process) {
  # Initialize a named list to store genes for each go process
  genes_list <- list()
  
  # For each go process, retrieve the genes and store into genes_list
  for (process in go_terms) {
    go_term <- define_go_process[[process]]
    if (is.null(go_term)) {
      warning(paste("GO term not found for the process:", process))
    } else {
      genes <- get_genes_for_go_process(go_term)
      genes_list[[process]] <- genes # Store list by process name
    }
  }
  
  print(genes_list)  # Debug print to check the expected structure
  
  genes_list  # Return the full list organized by process
}
