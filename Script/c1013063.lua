--Plaguespreader Zombie Dragon
function c1013063.initial_effect(c)
	--Name
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetValue(33420078)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1013063,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c1013063.spcost)
	e2:SetTarget(c1013063.sptg)
	e2:SetOperation(c1013063.spop)
	c:RegisterEffect(e2)
end
function c1013063.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c1013063.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c1013063.spfilter(c,e,tp,atk)
	return c:IsAttackBelow(atk) and c:IsLevelBelow(4) and c:GetCode()~=1013063 and (c:IsFaceup() or not c:IsLocation(LOCATION_EXTRA))
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c1013063.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,1)
	local def=0
	local atk=e:GetHandler():GetAttack()
	local flag=false
	if g and g:GetFirst():IsType(TYPE_MONSTER) then
		def=g:GetFirst():GetBaseDefense()
		atk=atk-def
		flag=true
	end
	if chk==0 then 
		if flag then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=1 
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>=1
			and Duel.IsPlayerCanSpecialSummon(tp)
			and Duel.IsExistingMatchingCard(c1013063.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp,atk)
		else
			e:SetLabel(1) 
			return true
		end
	end
end
function c1013063.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local g=Duel.GetDecktopGroup(tp,1)
	Duel.ConfirmDecktop(tp,1)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.DisableShuffleCheck()
		if tc:IsType(TYPE_MONSTER) and e:GetLabel()==0 then
			local def=tc:GetBaseDefense()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_IMMEDIATELY_APPLY)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-def)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			c:RegisterEffect(e1)
			Duel.ShuffleDeck(tp)
			local atk=c:GetAttack()
			local zg=Duel.GetMatchingGroup(c1013063.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA,0,nil,e,tp,atk)
			if not zg then return end
			local szg=zg:Select(tp,1,1,nil)
			if szg and szg:GetCount()>0 then
				Duel.SpecialSummon(szg,0,tp,tp,false,false,POS_FACEUP)
			end
		else
			if not tc:IsType(TYPE_MONSTER) then
				Duel.MoveSequence(tc,1)
			end
		end
	end
end
function c1013063.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_ZOMBIE)
end