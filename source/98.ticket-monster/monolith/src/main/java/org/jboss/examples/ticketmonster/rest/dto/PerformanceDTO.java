package org.jboss.examples.ticketmonster.rest.dto;

import java.io.Serializable;
import org.jboss.examples.ticketmonster.model.Performance;
import jakarta.persistence.EntityManager;
import org.jboss.examples.ticketmonster.rest.dto.NestedShowDTO;
import java.util.Date;
import jakarta.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class PerformanceDTO implements Serializable
{

   private Long id;
   private NestedShowDTO show;
   private Date date;
   private String displayTitle;

   public PerformanceDTO()
   {
   }

   public PerformanceDTO(final Performance entity)
   {
      if (entity != null)
      {
         this.id = entity.getId();
         this.show = new NestedShowDTO(entity.getShow());
         this.date = entity.getDate();
         this.displayTitle = entity.toString();
      }
   }

   public Performance fromDTO(Performance entity, EntityManager em)
   {
      if (entity == null)
      {
         entity = new Performance();
      }
      if (this.show != null)
      {
         entity.setShow(this.show.fromDTO(entity.getShow(), em));
      }
      entity.setDate(this.date);
      entity = em.merge(entity);
      return entity;
   }

   public Long getId()
   {
      return this.id;
   }

   public void setId(final Long id)
   {
      this.id = id;
   }

   public NestedShowDTO getShow()
   {
      return this.show;
   }

   public void setShow(final NestedShowDTO show)
   {
      this.show = show;
   }

   public Date getDate()
   {
      return this.date;
   }

   public void setDate(final Date date)
   {
      this.date = date;
   }

   public String getDisplayTitle()
   {
      return this.displayTitle;
   }
}
