//! Defines the possible errors in Unipept.

use std::io;
use std::num;

extern crate csv;

extern crate fst;

use taxon;

error_chain! {
    links {
        Taxon(taxon::Error, taxon::ErrorKind) #[doc = "Error propagated from Taxon"];
    }
    foreign_links {
        Csv(csv::Error) #[doc = "CSV"];
        Fst(fst::Error) #[doc = "Fst"];
        Io(io::Error) #[doc = "IO"];
        ParseI(num::ParseIntError) #[doc = "Parse Integer"];
        ParseF(num::ParseFloatError) #[doc = "Parse Float"];
    }
    errors {
        /// Invalid Frame TODO move this
        UnknownFrame(frame: String) {
            description("Couldn't parse a frame")
            display("Invalid frame: {}", frame)
        }
    }
}

