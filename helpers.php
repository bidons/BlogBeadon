<?php

function dd()
{
    array_map(function ($x) {
        echo (new \Phalcon\Debug\Dump(null, true))->variable($x);
    }, func_get_args());
    die(1);
}

if (!function_exists('appVersion')) {
    /**
     *
     * @return string
     */
    function appVersion(): string
    {
        $version_file = __DIR__.'/version';

        if (file_exists($version_file)) {
            return file_get_contents($version_file);
        }

        return '0.0.0';
    }
}

if (!function_exists('roundAmount')) {
    /**
     *
     * @param float $amount
     * @return mixed
     */
    function roundAmount($amount):float
    {
        return round(floatval($amount), 2);
    }
}

if (!function_exists('dateDiff')) {
    /**
     * Return the default value of the given value.
     *
     * @param $from
     * @param null $to
     * @return mixed
     */
    function dateDiff($from, $to = null)
    {
        if (is_string($from)) {
            $from = new \DateTime($from);
        }
        if (is_null($to) || is_string($to)) {
            $to = new \DateTime($to);
        }

        $interval = $from->diff($to);

        return $interval;
    }
}

// code taken from https://github.com/laravel/framework/blob/master/src/Illuminate/Foundation/helpers.php#L618
if (!function_exists('env')) {
    /**
     * Gets the value of an environment variable. Supports boolean, empty and null.
     *
     * @param  string $key
     * @param  mixed $default
     * @return mixed
     */
    function env($key, $default = null)
    {
        $value = getenv($key);

        if ($value === false) {
            return value($default);
        }

        switch (strtolower($value)) {
            case 'true':
            case '(true)':
                return true;
            case 'false':
            case '(false)':
                return false;
            case 'empty':
            case '(empty)':
                return '';
            case 'null':
            case '(null)':
                return null;
        }

        if ($value === '' && $value[0] === '"' && '"' === substr($value, -1)) {
            return substr($value, 1, -1);
        }

        return $value;
    }
}



if (!function_exists('str_num')) {

    function str_num($num) {
        static $nul = 'нуль';

        static $ten = [
            ['', 'один', 'два', 'три', 'чотири', 'п\'ять', 'шiсть', 'сiм', 'вiciм', 'дев\'ять'],
            ['', 'одна', 'дві', 'три', 'чотири', 'п\'ять', 'шість', 'сім', 'вісім', 'дев\'ять'],
        ];

        static $a20 = [
            'десять',
            'одинадцять',
            'дванадцать',
            'тринадцять',
            'чотирнадцять',
            'п\'ятнадцять',
            'шістнадцять',
            'сімнадцять',
            'вісімнадцять',
            'дев\'ятнадцять'
        ];

        static $tens = [
            2 => 'двадцять',
            'тридцять',
            'сорок',
            'п\'ятдесят',
            'шістдесят',
            'сімдесят',
            'вісімдесят',
            'дев\'яносто'
        ];

        static $hundred = [
            '',
            'сто',
            'двісті',
            'триста',
            'чотириста',
            'п\'ятсот',
            'шістсот',
            'сімсот',
            'вісімсот',
            'дев\'ятьсот'
        ];

        static $unit = [ // Units
            ['копійка', 'копійки',  'копійок',   1],
            ['гривня',  'гривні',   'гривень',   0],
            ['тисяча',  'тисячі',   'тисяч',     1],
            ['мільйон', 'мільйона', 'мільйонів', 0],
            ['мільярд', 'мільярда', 'мільярдів', 0],
        ];

        //
        list($rub, $kop) = explode('.', sprintf("%015.2f", floatval($num)));

        $out = [];
        if (intval($rub) > 0) {
            foreach(str_split($rub, 3) as $uk => $v) { // by 3 symbols
                if (!intval($v)) {
                    continue;
                }

                $uk = sizeof($unit) - $uk - 1; // unit key
                $gender = $unit[$uk][3];

                list($i1, $i2, $i3) = array_map('intval', str_split($v, 1));

                // mega-logic
                $out[] = $hundred[$i1]; # 1xx-9xx
                if ($i2 > 1) {
                    $out[]= $tens[$i2] . ' ' . $ten[$gender][$i3]; # 20-99
                } else {
                    $out[]= $i2 > 0 ? $a20[$i3] : $ten[$gender][$i3]; # 10-19 | 1-9
                }

                // units without rub & kop
                if ($uk > 1) {
                    $out[]= num_form($v, $unit[$uk][0], $unit[$uk][1], $unit[$uk][2]);
                }
            }
        } else {
            $out[] = $nul;
        }

        $out[] = num_form(intval($rub), $unit[1][0], $unit[1][1], $unit[1][2]); // rub
        $out[] = $kop . ' ' . num_form($kop, $unit[0][0], $unit[0][1], $unit[0][2]); // kop
        return trim(preg_replace('/ {2,}/', ' ', implode(' ', $out)));
    }

}

if (!function_exists('num_form')) {
    function num_form($n, $f1, $f2, $f5) {
        $n = abs(intval($n)) % 100;

        if ($n > 10 && $n < 20) {
            return $f5;
        }

        $n = $n % 10;
        if ($n > 1 && $n < 5) {
            return $f2;
        }
        if ($n == 1) {
            return $f1;
        }

        return $f5;
    }
}

