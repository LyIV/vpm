//extern create clap;
use clap::{Arg, App, SubCommand};

fn main() {
    let matches = App::new("vpm")
                          .version("1.0")
                          .author("0x04")
                          .about("simple vim plugin manager")
                          .subcommand(SubCommand::with_name("list")
                              .about("show plugin list"))
                          .subcommand(SubCommand::with_name("install")
                              .about("install plugin")
                              .arg(Arg::with_name("DIST")
                                  .help("plugin directory")
                                  .short("d")
                                  .long("dist")
                                  .takes_value(true))
                              .arg(Arg::with_name("PLUGIN_URI")
                                  .help("repository uri")
                                  .required(true)))
                          .subcommand(SubCommand::with_name("uninstall")
                              .arg(Arg::with_name("DIST")
                                  .help("plugin directory")
                                  .short("d")
                                  .long("dist")
                                  .takes_value(true))
                              .arg(Arg::with_name("PLUGIN_URI")
                                  .help("repository uri")
                                  .required(true)))
                              .about("uninstall plugin")
                          .subcommand(SubCommand::with_name("move")
                              .about("move plugin install directory")
                              .arg(Arg::with_name("SOURCE_DIR")
                                  .help("source directory")
                                  .takes_value(true)
                                  .required(true))
                              .arg(Arg::with_name("DEST_DIR")
                                  .help("destination directory")
                                  .takes_value(true)
                                  .required(true))
                              .arg(Arg::with_name("PLUGIN_NAME")
                                  .help("plugin name")
                                  .takes_value(true)
                                  .required(true)))
                          .get_matches();

    if let Some(matches) = matches.subcommand_matches("list") {
        println!("list")
    }

    if let Some(matches) = matches.subcommand_matches("install") {
        println!("install")
    }

    if let Some(matches) = matches.subcommand_matches("uninstall") {
        println!("uninstall")
    }

    if let Some(matches) = matches.subcommand_matches("switch") {
        println!("switch")
    }

}

