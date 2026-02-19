# ESPHome HomeAssistant Interface Panel

An ESPHome-based touch screen panel to install in your house to interface with HomeAssistant.
This project is based on the [esphome-modular-lvgl-buttons library][1].

## Hardware Required

Check the [esphome-modular-lvgl-buttons library][1] project for a list of supported (touch)screens.

I'm currently using the [WaveShare ESP32-S3-Touch-LCD-3.5B](https://www.waveshare.com/wiki/ESP32-S3-Touch-LCD-3.5B)

TODO ADD PHOTO


## Hardware Details


| Chip        | Type / Function            | What it does (short)                                   |
|-------------|----------------------------|--------------------------------------------------------|
| [AXS15231B](docs/AXS15231B_Datasheet_V0.5.pdf)   | Display Driver and Touch Panel Controller  | Drives LCD/TFT displays and touch panels       | 
| [QMI8658](docs/QMI8658C.pdf)     | IMU sensor                 | 6-axis motion sensing (accelerometer + gyroscope)      |
| [PCF85063](docs/PCF85063A.pdf)    | Real-Time Clock (RTC)      | Keeps date/time with ultra-low power                   |
| [AXP2101](docs/X-power-AXP2101_SWcharge_V1.0.pdf)     | Power Management IC (PMIC) | Battery charging, power regulation, power sequencing   |
| [ES8311](docs/ES8311.DS.pdf)      | Audio Codec                | Audio ADC/DAC for mic input and speaker/headphone out  |
| [W25Q128JVSIQ](docs/W25Q128JV.pdf) | External SPI flash memory | 16MB NOR-Flash Memory                                  |
| [TCA9554](docs/TCA9554.pdf)     | Port Expander              | Provides extra connections to e.g. LCD and Touch lines |

Block diagram:

```mermaid
flowchart LR
    USB[USB Type-C<br/>VBUS + USB D±]

    ESP[ESP32-S3<br/>Wi-Fi / BLE MCU]

    FLASH[SPI Flash<br/>W25Qxx]

    LCDDRV[AXS15231B<br/>LCD and Touch Controller]
    LCD[LCD Panel<br/>Backlight]

    AUDIO[ES8311<br/>Audio Codec]
    AMP[NS4150B<br/>Audio Amplifier]
    SPK[Speaker / Mic]

    IMU[QMI8658<br/>6-axis IMU]
    RTC[PCF85063<br/>RTC]

    IOX[TCA9554<br/>I/O Expander]

    PMIC[AXP2101<br/>PMIC + Charger]
    BAT[Li-Ion Battery]

    %% Connections
    USB -->|VBUS / USB| ESP
    USB -->|VBUS| PMIC

    PMIC -->|3V3 / 2V8 / RTC| ESP
    PMIC -->|Power Rails| LCDDRV
    PMIC -->|Power Rails| AUDIO
    PMIC -->|Power Rails| IMU
    PMIC -->|Power Rails| RTC
    PMIC -->|Power Rails| IOX

    BAT --> PMIC

    ESP -->|SPI / QSPI| FLASH
    ESP -->|SPI / QSPI| LCDDRV
    LCDDRV --> LCD

    ESP -->|I²C| LCDDRV
    ESP -->|I²C| IMU
    ESP -->|I²C| RTC
    ESP -->|I²C| IOX
    ESP -->|I²C| PMIC

    ESP -->|I²S| AUDIO
    AUDIO --> AMP
    AMP --> SPK
```

Mapping between ESP chip and the AXS15231B controller:

```
LCD_CS      GPIO12
LCD_SCLK    GPIO5
LCD_DATA0   GPIO1
LCD_DATA1   GPIO2
LCD_DATA2   GPIO3
LCD_DATA3   GPIO4
LCD_BL      GPIO6
```

and for the Touchscreen interface (TP interface):

```
TP_SCL      GPIO7
TP_SDA      GPIO8
TP_INT      Accessible via GPIO expander TCA9554PWR
```

The GPIO expander (ESP) TCA9554PWR is connected to the ESP32 chip using the I2C bus:

```
ESP_SCL      GPIO7
ESP_SDA      GPIO8
```


## Software

There are 2 ways to develop software for Waveshare devices, as suggested by Waveshare:

1. VSCode + ESP-IDF extension
2. Arduino IDE

However I've chosen a third way: using **ESPHome**.
I contributed to the [esphome-modular-lvgl-buttons library][1] the support for the Waveshare
hardware board and this repository contains a working `main.yaml` ESPHome configuration file that can be used to generate the actual firmware binary and flash it on the board.


## Integration with the wall box

In my country (Italy), the typical wall box is the so-called 503 model, with dimensions roughly equal to:

* width: 96mm
* height: 70mm
* depth: 48mm

These play well with the Waveshare 3.5'' board which has dimensions:

* width: 95mm
* height: 59mm
* depth: 14mm

Moreover the board has a connector on the back which supports injecting the 5V power
from a convenient power supply installed on the back of the panel:

<img src="./docs/waveshare-connector-layout.png">

Measurements of power usage: TODO

Power supply chosen: TODO

## Photos

TO BE WRITTEN

## How to Develop

TO BE WRITTEN

## Links

A few links to other similar projects:

* https://github.com/bennydiamond/esphome_lvgl_hmi_garage
 

[1]: https://github.com/agillis/esphome-modular-lvgl-buttons