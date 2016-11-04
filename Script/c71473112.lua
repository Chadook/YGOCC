--Fantasia Knight - Grandmaster
function c71473112.initial_effect(c)
	--Synchro Summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x1C1D),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--Material Check
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(c71473112.valcheck)
	c:RegisterEffect(e1)
	--Summon Success
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c71473112.regcon)
	e2:SetOperation(c71473112.regop)
	c:RegisterEffect(e2)
	e2:SetLabelObject(e1)
end
function c71473112.valcheck(e,c)
	local g=c:GetMaterial()
	local att=0
	local tc=g:GetFirst()
	while tc do
		att=bit.bor(att,tc:GetAttribute())
		tc=g:GetNext()
	end
	att=bit.band(att,0x37)
	e:SetLabel(att)
end
function c71473112.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
		and e:GetLabelObject():GetLabel()~=0
end
function c71473112.regop(e,tp,eg,ep,ev,re,r,rp)
	local att=e:GetLabelObject():GetLabel()
	local c=e:GetHandler()
	if bit.band(att,ATTRIBUTE_LIGHT)~=0 then
		local ae=Effect.CreateEffect(c)
		ae:SetType(EFFECT_TYPE_FIELD)
		ae:SetCode(EFFECT_UPDATE_ATTACK)
		ae:SetRange(LOCATION_MZONE)
		ae:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		ae:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x1C1D))
		ae:SetValue(500)
		ae:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(ae)
	end
	if bit.band(att,ATTRIBUTE_WATER)~=0 then
		local de=Effect.CreateEffect(c)
		de:SetType(EFFECT_TYPE_SINGLE)
		de:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		de:SetRange(LOCATION_MZONE)
		de:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		de:SetValue(1)
		de:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(de)
	end
	if bit.band(att,ATTRIBUTE_FIRE)~=0 then
		local e4=Effect.CreateEffect(c)
		e4:SetDescription(aux.Stringid(71473112,2))
		e4:SetCategory(CATEGORY_DESTROY)
		e4:SetType(EFFECT_TYPE_IGNITION)
		e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
		e4:SetRange(LOCATION_MZONE)
		e4:SetCountLimit(1)
		e4:SetTarget(c71473112.destg)
		e4:SetOperation(c71473112.desop)
		e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e4)
	end
	if bit.band(att,ATTRIBUTE_DARK)~=0 then
		local e5=Effect.CreateEffect(c)
		e5:SetDescription(aux.Stringid(71473112,3))
		e5:SetCategory(CATEGORY_REMOVE)
		e5:SetType(EFFECT_TYPE_IGNITION)
		e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
		e5:SetRange(LOCATION_MZONE)
		e5:SetCountLimit(1)
		e5:SetTarget(c71473112.remtg)
		e5:SetOperation(c71473112.remop)
		e5:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e5)
	end
	if bit.band(att,ATTRIBUTE_EARTH)~=0 then
		local e6=Effect.CreateEffect(c)
		e6:SetDescription(aux.Stringid(71473112,4))
		e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e6:SetType(EFFECT_TYPE_IGNITION)
		e6:SetRange(LOCATION_MZONE)
		e6:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
		e6:SetCountLimit(1)
		e6:SetTarget(c71473112.sptg)
		e6:SetOperation(c71473112.spop)
		e6:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e6)
	end
end
function c71473112.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsDesctructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDesctructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDesctructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c71473112.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(sg,REASON_EFFECT)
end
function c71473112.remfilter(c)
	return c:IsAbleToRemove()
end
function c71473112.remtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(c71473112.remfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c71473112.remfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,2,0,0)
end
function c71473112.remop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)	
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function c71473112.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_EXTRA+LOCATION_SZONE) and c71473112.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingMatchingCard(c71473112.spfilter,tp,LOCATION_EXTRA+LOCATION_SZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_SZONE)
end
function c71473112.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if ft>2 then ft=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c71473112.spfilter,tp,LOCATION_EXTRA+LOCATION_SZONE,0,1,ft,nil,e,tp)
	if g:GetCount()~=0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c71473112.spfilter(c,e,tp)
	return c:IsSetCard(0x1C1D) and ((c:GetSequence()==6 or c:GetSequence()==7) or c:IsFaceup()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end