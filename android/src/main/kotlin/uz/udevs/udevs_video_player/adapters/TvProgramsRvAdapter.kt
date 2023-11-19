package uz.udevs.udevs_video_player.adapters

import android.graphics.Color
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import uz.udevs.udevs_video_player.R
import uz.udevs.udevs_video_player.models.ProgramsInfo

class TvProgramsRvAdapter(var list: List<ProgramsInfo>) :
    RecyclerView.Adapter<TvProgramsRvAdapter.Vh>() {

    private var startIndex = 1
    private var hasSetFocus = false

    inner class Vh(itemView: View) : RecyclerView.ViewHolder(itemView) {
        val date: TextView
        val title: TextView
        val time: TextView

        init {
            date = itemView.findViewById(R.id.tv_program_date)
            title = itemView.findViewById(R.id.tv_program_item_title)
            time = itemView.findViewById(R.id.tv_program_item_time)
        }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): Vh {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.tv_program_item, parent, false)
        val holder = Vh(view)
        holder.itemView.setOnFocusChangeListener { _, b ->
            if (b) {
                holder.itemView.setBackgroundResource(R.drawable.focus_border)
            } else {
                holder.itemView.setBackgroundColor(Color.parseColor("#00FFFFFF"))
            }
        }
        return holder
    }

    override fun onBindViewHolder(holder: Vh, position: Int) {
        if (position == 0) {
            holder.date.visibility = View.VISIBLE
            holder.title.visibility = View.GONE
            holder.time.visibility = View.GONE
            holder.date.text = list[0].day
        }
        if (position > 0 && position <= list[0].tvPrograms.size) {
            holder.date.visibility = View.GONE
            holder.title.visibility = View.VISIBLE
            holder.time.visibility = View.VISIBLE
            holder.title.text = list[0].tvPrograms[position - 1].programTitle
            holder.time.text = list[0].tvPrograms[position - 1].scheduledTime
        }
        if (position == list[0].tvPrograms.size + 1) {
            holder.date.visibility = View.VISIBLE
            holder.title.visibility = View.GONE
            holder.time.visibility = View.GONE
            holder.date.text = list[1].day
        }
        if (position > list[0].tvPrograms.size + 1 && position <= list[0].tvPrograms.size + list[1].tvPrograms.size + 1) {
            holder.date.visibility = View.GONE
            holder.title.visibility = View.VISIBLE
            holder.time.visibility = View.VISIBLE
            holder.title.text =
                list[1].tvPrograms[position - list[0].tvPrograms.size - 2].programTitle
            holder.time.text =
                list[1].tvPrograms[position - list[0].tvPrograms.size - 2].scheduledTime
        }
        if (!hasSetFocus) {
            holder.itemView.requestFocus()
            hasSetFocus = true
        }
    }

    override fun getItemCount(): Int {
        var count = 0
        var additionalCount = 0
        for (i in startIndex until list.size) {
            count += list[i].tvPrograms.size
            additionalCount++
        }
        return count + additionalCount
    }

}