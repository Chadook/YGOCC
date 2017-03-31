--Cold Front
--  Idea: Alastar Rainford
--  Script: Shad3

local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local scard=_G[str]
	local s_id=tonumber(string.sub(str,2))
	return scard,s_id
end

local scard,s_id=getID()
local sc_id=0xa8d

function scard.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(7)
	e1:SetTarget(scard.a_tg)
	e1:SetOperation(scard.a_op)
	c:RegisterEffect(e1)
end

function scard.a_fil(c)
	return c:GetCounter(0x1015)>0
end

function scard.a_sfil(c,e,tp)
	return c:IsSetCard(sc_id) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function scard.a_tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(scard.a_fil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(scard.a_fil,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

function scard.a_op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,scard.a_fil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 and
	 Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
	 Duel.IsExistingMatchingCard(scard.a_sfil,tp,LOCATION_DECK,0,1,nil,e,tp) and
	 Duel.SelectYesNo(tp,aux.Stringid(s_id,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,scard.a_sfil,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		local fid=e:GetHandler():GetFieldID()
		tc:RegisterFlagEffect(s_id,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,fid)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCountLimit(1)
		e1:SetDescription(aux.Stringid(s_id,1))
		e1:SetCondition(scard.a_dcd)
		e1:SetOperation(scard.a_dop)
		if Duel.GetCurrentPhase()==PHASE_END and Duel.GetTurnPlayer()==tp then
			e1:SetValue(Duel.GetTurnCount())
		else
			e1:SetValue(0)
		end
		Duel.RegisterEffect(e1,tp)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc)
	end
end

function scard.a_dcd(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp or Duel.GetTurnCount()==e:GetValue() then return false end
	local tc=e:GetLabelObject()
	if tc and tc:GetFlagEffect(s_id)~=0 and tc:GetFlagEffectLabel(s_id)==e:GetLabel() then return true end
	e:Reset()
	return false
end

function scard.a_dop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetLabelObject(),REASON_EFFECT)
	e:Reset()
end
