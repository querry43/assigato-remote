extern crate pi_robot;
extern crate serde_json;

use std::fmt;

#[macro_use]
extern crate serde_derive;

#[derive(Serialize, Deserialize, Debug)]
pub enum Message {
    PWMChannelState(pi_robot::PWMChannelState),
    LEDDisplayState(pi_robot::LEDDisplayState),
    RobotSpeak(pi_robot::RobotSpeak),
}

impl fmt::Display for Message {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "{}", serde_json::to_string(self).unwrap())
    }
}

impl<'a> From<&'a str> for Message {
    fn from(s: &str) -> Self {
        serde_json::from_str(&s).unwrap()
    }
}

