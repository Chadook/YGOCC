--created & coded by Lyris
--Dimension Birth
function c101010173.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101010173.target)
	e1:SetOperation(c101010173.op)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(101010173,ACTIVITY_SPSUMMON,c101010173.ctfilter)
end
function c101010173.ctfilter(c)
	return c:GetSummonLocation()~=LOCATION_EXTRA
end
function c101010173.cfilter(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_REMOVED) and not c:IsImmuneToEffect(e)
end
function c101010173.filter1(c,djn,f,g)
	local lv=c:GetLevel()
	return (not f or f(c)) and c:IsAbleToGrave()
		and g:IsExists(c101010173.filter2,1,c,djn,f,c:GetAttribute(),c:GetRace(),lv)
end
function c101010173.filter2(c,djn,f,at,rc,lv)
	if not (c:GetAttribute()==at and c:GetRace()==rc
		and (not f or f(c)) and c:IsAbleToGrave()) then return false end
	return djn==lv or djn==c:GetLevel()
end
function c101010173.filter(c,e,tp)
	return c.spatial and c:IsCanBeSpecialSummoned(e,0x7150,tp,false,false)
end
function c101010173.sfilter(c,e,tp,m)
	return c101010173.filter(c,e,tp) and m:IsExists(c101010173.filter1,1,nil,c:GetRank(),c.material,m)
end
function c101010173.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 and Duel.GetCustomActivityCount(101010173,tp,ACTIVITY_SPSUMMON)==0 and Duel.IsExistingMatchingCard(c101010173.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	local rg=Duel.GetDecktopGroup(tp,5)
	Duel.DisableShuffleCheck()
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
	local g=Duel.GetOperatedGroup()
	g:KeepAlive()
	e:SetLabelObject(g)
	local mg=g:Filter(c101010173.cfilter,nil,e)
	if mg:GetCount()<=1 or not Duel.IsExistingMatchingCard(c101010173.sfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg) then return end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
--Banish the top 5 cards of your Deck; Spatial Summon 1 Spatial Monster from your Extra Deck, by returning 2 monsters among the banished cards to the Graveyard, and using them as its Space Materials. You cannot Special Summon other monsters from the Extra Deck during the turn you Special Summon using this card.
function c101010173.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=e:GetLabelObject()
	local mg=g:Filter(c101010173.cfilter,nil,e)
	g:DeleteGroup()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local sg=Duel.GetMatchingGroup(c101010173.sfilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg)
	if sg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local mc=mg:FilterSelect(tp,c101010173.filter1,1,1,nil,tc:GetRank(),tc.material,mg)
		local m1=mc:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local ms=mg:FilterSelect(tp,c101010173.filter2,1,1,m1,tc:GetRank(),tc.material,m1:GetAttribute(),m1:GetRace(),m1:GetLevel())
		mc:Merge(ms)
		tc:SetMaterial(mc)
		Duel.SendtoGrave(mc,REASON_EFFECT+REASON_MATERIAL+0x71500000000)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,0x7150,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_FIELD)
		e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e0:SetReset(RESET_PHASE+PHASE_END)
		e0:SetLabelObject(e)
		e0:SetTargetRange(1,0)
		e0:SetTarget(c101010173.sumlimit)
		Duel.RegisterEffect(e0,tp)
	end
end
function c101010173.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA)--[[ and e:GetLabelObject()~=se]]
end
