package uz.udevs.udevs_video_player.advertisement.theme

import androidx.compose.material3.Typography
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.Font
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.sp
import uz.udevs.udevs_video_player.R

val sfProFont = FontFamily(
    Font(R.font.regular, FontWeight.Normal),
    Font(R.font.semibold, FontWeight.SemiBold),
)

// Set of Material typography styles to start with
val Typography = Typography(
    labelMedium = TextStyle(
        fontFamily = sfProFont,
        color = Color.White,
        fontWeight = FontWeight.W600,
        fontSize = 18.sp,
    ),


    headlineLarge = TextStyle(
        fontFamily = sfProFont,
        color = Color.White,
        fontWeight = FontWeight.W700,
        fontSize = 34.sp,
    ),

    labelSmall = TextStyle(
        fontFamily = sfProFont,
        color = Color.White,
        fontWeight = FontWeight.W500,
        fontSize = 20.sp,
    ),

    bodySmall = TextStyle(
        fontFamily = sfProFont,
        color = Color.White,
        fontWeight = FontWeight.W400,
        fontSize = 20.sp,
    ),


    titleMedium = TextStyle(
        fontFamily = sfProFont,
        color = Color.White,
        fontWeight = FontWeight.W600,
        fontSize = 28.sp,
    ),


    titleLarge = TextStyle(
        fontFamily = sfProFont,
        color = Color.White,
        fontWeight = FontWeight.W600,
        fontSize = 32.sp,
    ),

    titleSmall = TextStyle(
        fontFamily = sfProFont,
        color = GrayText,
        fontWeight = FontWeight.W400,
        fontSize = 18.sp,
    )

)