--Last of the Phantasm
function c43811011.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c43811011.sptg)
	e1:SetOperation(c43811011.spop)
	c:RegisterEffect(e1)
end
function c43811011.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(43811011)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,43811011,0x90e,0x11,1200,1800,4,RACE_FIEND,ATTRIBUTE_DARK) end
	c:RegisterFlagEffect(43811011,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c43811011.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,43811011,0x90e,0x11,1200,1800,4,RACE_FIEND,ATTRIBUTE_DARK) then
		c:SetStatus(STATUS_NO_LEVEL,false)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_EFFECT+TYPE_MONSTER)
		e1:SetReset(RESET_EVENT+0x47c0000)
		c:RegisterEffect(e1,true)
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetValue(TYPE_TUNER)
		c:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		e3:SetValue(c43811011.synlimit)
		c:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e4:SetProperty(EFFECT_FLAG_DELAY)
		e4:SetCode(EVENT_TO_GRAVE)
		e4:SetTarget(c43811011.retg)
		e4:SetOperation(c43811011.reop)
		e4:SetReset(RESET_EVENT+0x17a0000)
		c:RegisterEffect(e4)
	end
end
function c43811011.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=1 end
end
function c43811011.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local g=Duel.GetDecktopGroup(tp,1)
	Duel.ConfirmDecktop(tp,1)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.DisableShuffleCheck()
		Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(43811011,0))
		local op=Duel.SelectOption(1-tp,aux.Stringid(43811011,1),aux.Stringid(43811011,2))
		if op==1 then
			Duel.MoveSequence(tc,1)
		else
			Duel.MoveSequence(tc,0)
		end
	end
end
function c43811011.synlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x90e)
end