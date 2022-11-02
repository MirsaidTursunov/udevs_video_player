package uz.udevs.udevs_video_player.adapters

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.AsyncListDiffer
import androidx.recyclerview.widget.DiffUtil
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.Glide
import uz.udevs.udevs_video_player.R
import uz.udevs.udevs_video_player.databinding.EpisodeItemBinding
import uz.udevs.udevs_video_player.models.Movie
import uz.udevs.udevs_video_player.utils.MyHelper

class EpisodesRvAdapter(var context: Context, var onClickListener: OnClickListener) :
    RecyclerView.Adapter<EpisodesRvAdapter.Vh>() {

    private val differCallback = object : DiffUtil.ItemCallback<Movie>() {
        override fun areItemsTheSame(oldItem: Movie, newItem: Movie): Boolean {
            return oldItem.id == newItem.id
        }

        override fun areContentsTheSame(oldItem: Movie, newItem: Movie): Boolean {
            return oldItem == newItem
        }

    }

    val differ = AsyncListDiffer(this, differCallback)

    inner class Vh(private var binding: EpisodeItemBinding) :
        RecyclerView.ViewHolder(binding.root) {

        fun onBind(episode: Movie?, position: Int) {
            binding.episodeItemTitle.text = episode?.title
            binding.episodeItemDescription.text = episode?.description
            binding.episodeItemDuration.text =
                episode?.duration?.let { MyHelper().formatDuration(it) }
            if (episode?.image?.isNotEmpty() == true) {
                Glide.with(context)
                    .load(episode.image)
                    .placeholder(R.drawable.movie_fill)
                    .into(binding.episodeItemImage)
            }
            binding.episodeItemImage.setOnClickListener {
                onClickListener.onClick(position)
            }

        }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): Vh {
        return Vh(EpisodeItemBinding.inflate(LayoutInflater.from(parent.context), parent, false))
    }

    override fun onBindViewHolder(holder: Vh, position: Int) =
        holder.onBind(differ.currentList[position], position)


    override fun getItemCount(): Int {
        return differ.currentList.size
    }

    interface OnClickListener {
        fun onClick(index: Int)
    }

}