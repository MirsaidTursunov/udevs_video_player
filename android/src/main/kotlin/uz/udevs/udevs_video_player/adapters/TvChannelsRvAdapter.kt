package uz.udevs.udevs_video_player.adapters

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.Glide
import uz.udevs.udevs_video_player.R
import uz.udevs.udevs_video_player.models.TvChannel

class TvChannelsRvAdapter(
    var context: Context,
    var list: List<TvChannel>,
    private var onClickListener: OnClickListener
) :
    RecyclerView.Adapter<TvChannelsRvAdapter.Vh>() {

    inner class Vh(itemView: View) : RecyclerView.ViewHolder(itemView) {
        val image: ImageView
        val lock: ImageView

        init {
            image = itemView.findViewById(R.id.channel_image)
            lock = itemView.findViewById(R.id.lock_image)
        }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): Vh {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.item_channel, parent, false)
        return Vh(view)
    }

    override fun onBindViewHolder(holder: Vh, position: Int) {
        if (list[position].hasAccess) {
            holder.lock.visibility = View.GONE
        } else {
            holder.lock.visibility = View.VISIBLE
        }
        Glide.with(context)
            .load(list[position].image)
            .placeholder(R.drawable.logo_secondary)
            .into(holder.image)
        holder.image.setOnClickListener {
            onClickListener.onClick(position)
        }
    }

    override fun getItemCount(): Int {
        return list.size
    }

    interface OnClickListener {
        fun onClick(index: Int)
    }
}