
extern crate unipept;

use unipept::taxon::*;

pub fn taxon_list() -> Vec<Taxon> {
    vec![
        Taxon::from_static(1,      "root",          Rank::NoRank,       1,     true),
        Taxon::from_static(2,      "Bacteria",      Rank::Superkingdom, 1,     true),
        Taxon::from_static(10239,  "Viruses",       Rank::Superkingdom, 1,     true),
        Taxon::from_static(12884,  "Viroids",       Rank::Superkingdom, 1,     true),
        Taxon::from_static(185751, "Pospiviroidae", Rank::Family,       12884, true),
        Taxon::from_static(185752, "Avsunviroidae", Rank::Family,       12884, true),
    ]
}

