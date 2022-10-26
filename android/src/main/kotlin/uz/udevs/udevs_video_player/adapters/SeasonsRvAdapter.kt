package uz.udevs.udevs_video_player.adapters

import android.content.Context
import android.opengl.Visibility
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import uz.udevs.udevs_video_player.R
import uz.udevs.udevs_video_player.models.Season

class SeasonsRvAdapter(
    var context: Context,
    var list: List<Season>,
    var onClickListener: OnClickListener,
    var selectedIndex: Int
) :
    RecyclerView.Adapter<SeasonsRvAdapter.Vh>() {

    inner class Vh(itemView: View) : RecyclerView.ViewHolder(itemView) {
        val title: TextView
        val check: ImageView

        init {
            title = itemView.findViewById(R.id.tv_season)
            check = itemView.findViewById(R.id.ic_check)

        }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): Vh {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.season_item, parent, false)

        return Vh(view)
    }

    override fun onBindViewHolder(holder: Vh, position: Int) {
        holder.title.text = list[position].title
        if (position == selectedIndex) {
            holder.check.visibility = View.VISIBLE
        }
        holder.itemView.setOnClickListener {
            onClickListener.onClick(position)
        }
    }

    override fun getItemCount(): Int {
        return list.size
    }

    interface OnClickListener {
        fun onClick(seasonPosition: Int)
    }
}