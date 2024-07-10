package uz.udevs.udevs_video_player.activities

import android.annotation.SuppressLint
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.height
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import uz.udevs.udevs_video_player.models.AdvertisementResponse

@SuppressLint("UnusedMaterial3ScaffoldPaddingParameter")
@Composable
fun AdvertisementPage(advertisement: AdvertisementResponse,onClick: ()->Unit) {
    Scaffold{
        Column(modifier=Modifier.clickable {onClick.invoke()  }) {
            Text("Advertisement ")
            Spacer(modifier = Modifier.height(20.dp))
            Text("Advertisement $advertisement")
        }
    }
}